module Rsyslog
  module Cookbook
    module Helpers
      def rsyslog_relp_package
        if platform_family?('suse')
          'rsyslog-module-relp'
        else
          'rsyslog-relp'
        end
      end
    end
  end
end

Chef::DSL::Recipe.include Rsyslog::Cookbook::Helpers
Chef::Resource.include Rsyslog::Cookbook::Helpers
