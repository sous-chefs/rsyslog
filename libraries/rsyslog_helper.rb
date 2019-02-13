module Rsyslog
  module Helper
    # If `config_style` for the node is `legacy`, add a `-legacy` label prior
    # to the final file suffix of an ERB template.
    def labeled_template(path, style)
      path.gsub(/^(.*)(\.conf\.erb)/, "\\1#{style == 'legacy' ? '-legacy' : ''}\\2")
    end
  end
end
