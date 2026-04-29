# frozen_string_literal: true

provides :rsyslog_server
unified_mode true

use '_partial/_config'

property :instance, String, name_property: true
property :log_dir, String, default: '/srv/rsyslog'
property :per_host_dir, String, default: '%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%'
property :allow_non_local, [true, false], default: false
property :server_per_host_template, String, default: '35-server-per-host.conf.erb'
property :server_per_host_cookbook, String, default: 'rsyslog'

default_action :create

action_class do
  include Rsyslog::Cookbook::Helpers
end

action :create do
  rsyslog_service new_resource.instance do
    rsyslog_common_properties(new_resource).each { |property_name, property_value| public_send(property_name, property_value) }
    server true
    action :create
  end

  directory new_resource.log_dir do
    owner effective_dir_owner(new_resource)
    group effective_dir_group(new_resource)
    mode new_resource.dir_create_mode
    recursive true
  end

  template ::File.join(rsyslog_config_dir, '35-server-per-host.conf') do
    cookbook new_resource.server_per_host_cookbook
    source new_resource.server_per_host_template
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    mode new_resource.config_file_mode
    variables(
      allow_non_local: new_resource.allow_non_local,
      group: effective_group(new_resource),
      log_dir: new_resource.log_dir,
      per_host_dir: new_resource.per_host_dir,
      relp_port: new_resource.relp_port,
      use_relp: new_resource.use_relp
    )
    notifies :run, 'execute[validate_config]'
    notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
  end

  file ::File.join(rsyslog_config_dir, '49-remote.conf') do
    action :delete
    notifies :run, 'execute[validate_config]'
    notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
  end
end

action :delete do
  file ::File.join(rsyslog_config_dir, '35-server-per-host.conf') do
    action :delete
  end

  file ::File.join(rsyslog_config_dir, '49-remote.conf') do
    action :delete
  end

  directory new_resource.log_dir do
    recursive true
    action :delete
  end

  rsyslog_service new_resource.instance do
    rsyslog_common_properties(new_resource).each { |property_name, property_value| public_send(property_name, property_value) }
    action :delete
  end
end
