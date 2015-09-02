module RsyslogCookbook
  # helpers for the various service providers on Ubuntu systems
  module Helpers
    def declare_rsyslog_service
      if  'ubuntu' == node['platform']
        if Chef::VersionConstraint.new('>= 15.04').include?(node['platform_version'])
          service_provider = Chef::Provider::Service::Systemd
        elsif Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])
          service_provider = Chef::Provider::Service::Upstart
        else
          service_provider = nil
        end
      end

      service 'rsyslog' do
        service_name node['rsyslog']['service_name']
        supports :restart => true, :status => true
        action   [:enable, :start]
        provider service_provider
      end
    end
  end
end
