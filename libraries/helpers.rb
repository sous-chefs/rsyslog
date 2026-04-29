# frozen_string_literal: true

module Rsyslog
  module Cookbook
    module Helpers
      unless const_defined?(:COMMON_PROPERTIES, false)
        COMMON_PROPERTIES = %i(
          action_queue_max_disk_space
          additional_directives
          bind
          config_file_group
          config_file_mode
          config_file_owner
          config_prefix
          config_style
          default_conf_file
          default_facility_logs
          default_file_template
          default_log_dir
          default_remote_template
          dir_create_mode
          dir_group
          dir_owner
          enable_tls
          file_create_mode
          group
          high_precision_timestamps
          imfile_parameters
          local_host_name
          logs_to_forward
          max_message_size
          module_directives
          modules
          package_name
          port
          preserve_fqdn
          priv_group
          priv_seperation
          priv_user
          protocol
          rate_limit_burst
          rate_limit_interval
          relp_port
          repeated_msg_reduction
          service_name
          templates
          tls_auth_mode
          tls_ca_file
          tls_certificate_file
          tls_driver
          tls_key_file
          tls_permitted_peer
          tcp_max_sessions
          umask
          use_relp
          user
          working_dir
          working_dir_mode
        ).freeze
      end

      def rsyslog_common_properties(resource)
        COMMON_PROPERTIES.to_h { |property_name| [property_name, resource.public_send(property_name)] }
      end

      def rsyslog_config_dir(resource = new_resource)
        ::File.join(effective_config_prefix(resource), 'rsyslog.d')
      end

      def rsyslog_config_file(resource = new_resource)
        ::File.join(effective_config_prefix(resource), 'rsyslog.conf')
      end

      def rsyslog_service_unit(resource = new_resource)
        service = effective_service_name(resource)
        service.end_with?('.service') ? service : "#{service}.service"
      end

      def rsyslog_relp_package
        platform_family?('suse') ? 'rsyslog-module-relp' : 'rsyslog-relp'
      end

      def labeled_template(path, style)
        path.gsub(/^(.*)(\.conf\.erb)/, "\\1#{style == 'legacy' ? '-legacy' : ''}\\2")
      end

      def default_config_prefix
        '/etc'
      end

      def default_working_dir
        platform_family?('rhel', 'fedora', 'amazon') ? '/var/lib/rsyslog' : '/var/spool/rsyslog'
      end

      def default_service_name
        platform_family?('suse') ? 'syslog' : 'rsyslog'
      end

      def default_user
        platform?('ubuntu') ? 'syslog' : 'root'
      end

      def default_group
        platform_family?('suse') ? 'root' : 'adm'
      end

      def default_dir_owner
        platform?('ubuntu') ? 'syslog' : 'root'
      end

      def default_dir_group
        platform_family?('suse') ? 'trusted' : 'adm'
      end

      def default_priv_seperation
        platform?('ubuntu')
      end

      def default_priv_group
        platform?('ubuntu') ? 'syslog' : nil
      end

      def default_tls_driver
        'ossl'
      end

      def default_modules
        platform_family?('rhel', 'fedora', 'amazon') ? %w(imuxsock imjournal) : %w(imuxsock imklog)
      end

      def default_module_directives
        directives = { 'imuxsock' => { 'SysSock.Use' => 'off' } }
        directives['imjournal'] = { 'UsePid' => 'system', 'StateFile' => 'imjournal.state' } if platform_family?('rhel', 'fedora', 'amazon')
        directives
      end

      def default_facility_logs(default_log_dir = '/var/log')
        case node['platform_family']
        when 'suse'
          suse_facility_logs(default_log_dir)
        when 'rhel', 'fedora', 'amazon'
          rhel_facility_logs(default_log_dir)
        else
          debian_facility_logs(default_log_dir)
        end
      end

      def effective_config_prefix(resource)
        resource.config_prefix || default_config_prefix
      end

      def effective_service_name(resource)
        resource.service_name || default_service_name
      end

      def effective_working_dir(resource)
        resource.working_dir || default_working_dir
      end

      def effective_user(resource)
        resource.user || default_user
      end

      def effective_group(resource)
        resource.group || default_group
      end

      def effective_dir_owner(resource)
        resource.dir_owner || default_dir_owner
      end

      def effective_dir_group(resource)
        resource.dir_group || default_dir_group
      end

      def effective_priv_seperation(resource)
        resource.priv_seperation.nil? ? default_priv_seperation : resource.priv_seperation
      end

      def effective_priv_group(resource)
        resource.priv_group || default_priv_group
      end

      def effective_tls_driver(resource)
        resource.tls_driver || default_tls_driver
      end

      def effective_modules(resource)
        resource.modules || default_modules
      end

      def effective_module_directives(resource)
        resource.module_directives || default_module_directives
      end

      def effective_default_facility_logs(resource)
        resource.default_facility_logs || default_facility_logs(resource.default_log_dir)
      end

      def debian_facility_logs(default_log_dir)
        {
          'auth,authpriv.*' => "#{default_log_dir}/auth.log",
          '*.*;auth,authpriv.none' => "-#{default_log_dir}/syslog",
          'daemon.*' => "-#{default_log_dir}/daemon.log",
          'kern.*' => "-#{default_log_dir}/kern.log",
          'mail.*' => "-#{default_log_dir}/mail.log",
          'user.*' => "-#{default_log_dir}/user.log",
          'mail.info' => "-#{default_log_dir}/mail.info",
          'mail.warn' => "-#{default_log_dir}/mail.warn",
          'mail.err' => "#{default_log_dir}/mail.err",
          'news.crit' => "#{default_log_dir}/news/news.crit",
          'news.err' => "#{default_log_dir}/news/news.err",
          'news.notice' => "-#{default_log_dir}/news/news.notice",
          '*.=debug;auth,authpriv.none;news.none;mail.none' => "-#{default_log_dir}/debug",
          '*.=info;*.=notice;*.=warn;auth,authpriv.none;cron,daemon.none;mail,news.none' => "-#{default_log_dir}/messages",
          '*.emerg' => ':omusrmsg:*',
        }
      end

      def rhel_facility_logs(default_log_dir)
        {
          '*.info;mail.none;authpriv.none;cron.none' => "#{default_log_dir}/messages",
          'authpriv.*' => "#{default_log_dir}/secure",
          'mail.*' => "-#{default_log_dir}/maillog",
          'cron.*' => "#{default_log_dir}/cron",
          '*.emerg' => ':omusrmsg:*',
          'uucp,news.crit' => "#{default_log_dir}/spooler",
          'local7.*' => "#{default_log_dir}/boot.log",
        }
      end

      def suse_facility_logs(default_log_dir)
        {
          '*.emerg' => ':omusrmsg:*',
          'mail.*' => "-#{default_log_dir}/mail.log",
          'mail.info' => "-#{default_log_dir}/mail.info",
          'mail.warning' => "-#{default_log_dir}/mail.warn",
          'mail.err' => "#{default_log_dir}/mail.err",
          'news.crit' => "#{default_log_dir}/news/news.crit",
          'news.err' => "#{default_log_dir}/news/news.err",
          'news.notice' => "-#{default_log_dir}/news/news.notice",
          '*.=warning;*.=err' => "-#{default_log_dir}/warn",
          '*.crit' => "#{default_log_dir}/warn",
          '*.*;mail.none;news.none' => "#{default_log_dir}/messages",
          'local0.*;local1.*' => "-#{default_log_dir}/localmessages",
          'local2.*;local3.*' => "-#{default_log_dir}/localmessages",
          'local4.*;local5.*' => "-#{default_log_dir}/localmessages",
          'local6.*;local7.*' => "-#{default_log_dir}/localmessages",
        }
      end
    end
  end
end
