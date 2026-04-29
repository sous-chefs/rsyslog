# frozen_string_literal: true

provides :rsyslog_service
unified_mode true

use '_partial/_config'

property :instance, String, name_property: true
property :server, [true, false], default: false

default_action :create

action_class do
  include Rsyslog::Cookbook::Helpers

  def rsyslog_template_variables(resource, server)
    {
      additional_directives: resource.additional_directives,
      bind: resource.bind,
      config_prefix: effective_config_prefix(resource),
      default_facility_logs: effective_default_facility_logs(resource),
      default_file_template: resource.default_file_template,
      dir_create_mode: resource.dir_create_mode,
      dir_group: effective_dir_group(resource),
      dir_owner: effective_dir_owner(resource),
      enable_tls: resource.enable_tls,
      file_create_mode: resource.file_create_mode,
      group: effective_group(resource),
      high_precision_timestamps: resource.high_precision_timestamps,
      local_host_name: resource.local_host_name,
      max_message_size: resource.max_message_size,
      module_directives: effective_module_directives(resource),
      modules: effective_modules(resource),
      port: resource.port,
      preserve_fqdn: resource.preserve_fqdn,
      priv_group: effective_priv_group(resource),
      priv_seperation: effective_priv_seperation(resource),
      priv_user: resource.priv_user,
      protocol: resource.protocol,
      rate_limit_burst: resource.rate_limit_burst,
      rate_limit_interval: resource.rate_limit_interval,
      repeated_msg_reduction: resource.repeated_msg_reduction,
      server: server,
      templates: resource.templates,
      tls_auth_mode: resource.tls_auth_mode,
      tls_ca_file: resource.tls_ca_file,
      tls_certificate_file: resource.tls_certificate_file,
      tls_driver: effective_tls_driver(resource),
      tls_key_file: resource.tls_key_file,
      tcp_max_sessions: resource.tcp_max_sessions,
      umask: resource.umask,
      user: effective_user(resource),
      working_dir: effective_working_dir(resource),
    }
  end
end

action :create do
  if new_resource.enable_tls && new_resource.tls_ca_file && new_resource.protocol != 'tcp'
    raise "rsyslog_service cannot enable TLS with protocol '#{new_resource.protocol}' (requires 'tcp')"
  end

  package new_resource.package_name

  package rsyslog_relp_package do
    action :install
    only_if { new_resource.use_relp }
  end

  package "#{new_resource.package_name}-#{effective_tls_driver(new_resource) == 'gtls' ? 'gnutls' : 'openssl'}" do
    action :install
    only_if { new_resource.enable_tls }
  end

  directory rsyslog_config_dir do
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    mode new_resource.config_dir_mode
  end

  directory effective_working_dir(new_resource) do
    owner effective_user(new_resource)
    group effective_group(new_resource)
    mode new_resource.working_dir_mode
    recursive true
  end

  execute 'validate_config' do
    command "rsyslogd -N 1 -f #{rsyslog_config_file}"
    action :nothing
  end

  template rsyslog_config_file do
    cookbook 'rsyslog'
    source 'rsyslog.conf.erb'
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    mode new_resource.config_file_mode
    variables rsyslog_template_variables(new_resource, new_resource.server)
    notifies :run, 'execute[validate_config]'
    notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
  end

  template ::File.join(rsyslog_config_dir, '35-imfile.conf') do
    cookbook 'rsyslog'
    source labeled_template('35-imfile.conf.erb', new_resource.config_style)
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    mode new_resource.config_file_mode
    variables module_parameters: new_resource.imfile_parameters
    notifies :run, 'execute[validate_config]'
    notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
    action :nothing
  end

  template ::File.join(rsyslog_config_dir, '50-default.conf') do
    cookbook 'rsyslog'
    source '50-default.conf.erb'
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    mode new_resource.config_file_mode
    variables default_facility_logs: effective_default_facility_logs(new_resource)
    notifies :run, 'execute[validate_config]'
    notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
    only_if { new_resource.default_conf_file }
  end

  systemd_unit rsyslog_service_unit do
    action [:enable, :start]
  end
end

action :delete do
  systemd_unit rsyslog_service_unit do
    action [:stop, :disable]
  end

  file ::File.join(rsyslog_config_dir, '35-imfile.conf') do
    action :delete
  end

  file ::File.join(rsyslog_config_dir, '50-default.conf') do
    action :delete
  end

  file rsyslog_config_file do
    action :delete
  end

  directory effective_working_dir(new_resource) do
    recursive true
    action :delete
  end

  directory rsyslog_config_dir do
    recursive true
    action :delete
  end

  package rsyslog_relp_package do
    action :remove
    only_if { new_resource.use_relp }
  end

  package "#{new_resource.package_name}-#{effective_tls_driver(new_resource) == 'gtls' ? 'gnutls' : 'openssl'}" do
    action :remove
    only_if { new_resource.enable_tls }
  end

  package new_resource.package_name do
    action :remove
  end
end

action :start do
  systemd_unit rsyslog_service_unit do
    action :start
  end
end

action :stop do
  systemd_unit rsyslog_service_unit do
    action :stop
  end
end

action :restart do
  systemd_unit rsyslog_service_unit do
    action :restart
  end
end

action :reload do
  systemd_unit rsyslog_service_unit do
    action :reload
  end
end
