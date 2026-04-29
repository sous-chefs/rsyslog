# frozen_string_literal: true

property :package_name, String, default: 'rsyslog'
property :service_name, [String, nil]
property :config_prefix, [String, nil]
property :config_style, [String, nil], equal_to: %w(legacy), default: nil
property :config_file_owner, String, default: 'root'
property :config_file_group, String, default: 'root'
property :config_file_mode, String, default: '0644'
property :config_dir_mode, String, default: '0755'

property :working_dir, [String, nil]
property :working_dir_mode, String, default: '0700'
property :user, [String, nil]
property :group, [String, nil]
property :dir_owner, [String, nil]
property :dir_group, [String, nil]
property :file_create_mode, String, default: '0640'
property :dir_create_mode, String, default: '0755'
property :umask, String, default: '0022'

property :local_host_name, [String, nil], default: nil
property :max_message_size, [String, nil, false], default: '2k'
property :preserve_fqdn, String, equal_to: %w(on off), default: 'off'
property :high_precision_timestamps, [true, false], default: false
property :repeated_msg_reduction, String, equal_to: %w(on off), default: 'on'
property :default_log_dir, String, default: '/var/log'
property :default_facility_logs, [Hash, nil]
property :default_file_template, [String, nil], default: nil
property :default_remote_template, [String, nil], default: nil
property :templates, Array, default: []
property :modules, [Array, nil]
property :module_directives, [Hash, nil]
property :additional_directives, Hash, default: {}
property :rate_limit_interval, [Integer, String, nil], default: nil
property :rate_limit_burst, [Integer, String, nil], default: nil

property :protocol, String, default: 'tcp'
property :bind, String, default: '*'
property :port, [Integer, String], default: 514
property :logs_to_forward, String, default: '*.*'
property :action_queue_max_disk_space, String, default: '1G'
property :tcp_max_sessions, [Integer, String], default: 200

property :use_relp, [true, false], default: false
property :relp_port, [Integer, String], default: 20_514

property :enable_tls, [true, false], default: false
property :tls_driver, [String, nil], equal_to: %w(ossl gtls)
property :tls_ca_file, [String, nil], default: nil
property :tls_certificate_file, [String, nil], default: nil
property :tls_key_file, [String, nil], default: nil
property :tls_auth_mode, String, default: 'anon'
property :tls_permitted_peer, [String, nil], default: nil

property :priv_seperation, [true, false, nil]
property :priv_user, [String, nil], default: nil
property :priv_group, [String, nil]

property :imfile_parameters, Hash, default: {}
property :default_conf_file, [true, false], default: true
