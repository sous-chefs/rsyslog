module RsyslogCookbook
  # helpers for the various service providers on Ubuntu systems
  module Helpers
    # use the correct provider based on the Ubuntu release
    def find_service_provider
      if Chef::VersionConstraint.new('>= 15.04').include?(node['platform_version'])
        service_provider = Chef::Provider::Service::Systemd
      elsif Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])
        service_provider = Chef::Provider::Service::Upstart
      else
        service_provider = nil
      end
      service_provider
    end

    # declare the service with the appropriate provider if on Ubuntu
    def declare_rsyslog_service
      service_provider = 'ubuntu' == node['platform'] ? find_service_provider : nil

      service node['rsyslog']['service_name'] do
        supports restart: true, status: true
        action   [:enable, :start]
        provider service_provider
      end
    end

    # determine if chef solo search is available
    def chef_solo_search_installed?
      klass = ::Search.const_get('Helper')
      return klass.is_a?(Class)
    rescue NameError
      return false
    end

  end
end
