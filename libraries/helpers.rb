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

      # If `config_style` for the node is `legacy`, add a `-legacy` label prior
      # to the final file suffix of an ERB template.
      def labeled_template(path, style)
        path.gsub(/^(.*)(\.conf\.erb)/, "\\1#{style == 'legacy' ? '-legacy' : ''}\\2")
      end
    end
  end
end

Chef::DSL::Recipe.include Rsyslog::Cookbook::Helpers
Chef::Resource.include Rsyslog::Cookbook::Helpers
