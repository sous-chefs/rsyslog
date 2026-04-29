# frozen_string_literal: true

provides :rsyslog_client
unified_mode true

use '_partial/_config'

property :instance, String, name_property: true
property :server_ip, [String, Array, nil], default: nil
property :server_search, [String, nil]
property :remote_logs, [true, false], default: true
property :custom_remote, Array, default: []
property :use_local_ipv4, [true, false], default: false

default_action :create

action_class do
  include Rsyslog::Cookbook::Helpers

  def searched_server_ips(resource)
    return [] if resource.server_search.to_s.empty?

    search(:node, resource.server_search).map do |server|
      if resource.use_local_ipv4 && server.attribute?('cloud') && server['cloud']['local_ipv4']
        server['cloud']['local_ipv4']
      else
        server['ipaddress']
      end
    end
  end

  def rsyslog_servers(resource)
    server_ips = Array(resource.server_ip) + searched_server_ips(resource)
    servers = server_ips.map do |ip|
      {
        'server' => ip,
        'port' => resource.port,
        'logs' => resource.logs_to_forward,
        'protocol' => resource.protocol,
        'remote_template' => resource.default_remote_template,
      }
    end

    unless resource.custom_remote.empty? || resource.custom_remote.first.empty?
      resource.custom_remote.each do |server|
        raise 'Found a custom_remote server with no IP. Check your custom_remote property definition!' if server['server'].nil?
      end
      servers += resource.custom_remote
    end

    servers
  end
end

action :create do
  rsyslog_service new_resource.instance do
    rsyslog_common_properties(new_resource).each { |property_name, property_value| public_send(property_name, property_value) }
    action :create
  end

  servers = rsyslog_servers(new_resource)

  if servers.empty?
    Chef::Log.warn('rsyslog_client was unable to determine the remote syslog server. Not forwarding logs.')
  else
    remote_type = new_resource.use_relp ? 'relp' : 'remote'
    template ::File.join(rsyslog_config_dir, '49-remote.conf') do
      cookbook 'rsyslog'
      source "49-#{remote_type}.conf.erb"
      owner new_resource.config_file_owner
      group new_resource.config_file_group
      mode new_resource.config_file_mode
      variables(
        action_queue_max_disk_space: new_resource.action_queue_max_disk_space,
        default_remote_template: new_resource.default_remote_template,
        enable_tls: new_resource.enable_tls,
        logs_to_forward: new_resource.logs_to_forward,
        port: new_resource.port,
        protocol: new_resource.protocol,
        relp_port: new_resource.relp_port,
        servers: servers,
        tls_auth_mode: new_resource.tls_auth_mode,
        tls_ca_file: new_resource.tls_ca_file,
        tls_certificate_file: new_resource.tls_certificate_file,
        tls_key_file: new_resource.tls_key_file,
        tls_permitted_peer: new_resource.tls_permitted_peer
      )
      notifies :run, 'execute[validate_config]'
      notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
      only_if { new_resource.remote_logs }
    end

    file ::File.join(rsyslog_config_dir, '35-server-per-host.conf') do
      action :delete
      notifies :run, 'execute[validate_config]'
      notifies :restart, "systemd_unit[#{rsyslog_service_unit}]"
    end
  end
end

action :delete do
  file ::File.join(rsyslog_config_dir, '49-remote.conf') do
    action :delete
  end

  file ::File.join(rsyslog_config_dir, '35-server-per-host.conf') do
    action :delete
  end

  rsyslog_service new_resource.instance do
    rsyslog_common_properties(new_resource).each { |property_name, property_value| public_send(property_name, property_value) }
    action :delete
  end
end
