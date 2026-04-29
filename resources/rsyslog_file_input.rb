# frozen_string_literal: true

provides :rsyslog_file_input
unified_mode true

use '_partial/_config'

property :input_name, String, name_property: true
property :file, String, required: true
property :priority, Integer, default: 99
property :severity, [String, nil], equal_to: %w(emergency alert critical error warning notice info debug)
property :facility, [String, nil], equal_to: %w(auth authpriv daemon cron ftp lpr kern mail news syslog user uucp local0 local1 local2 local3 local4 local5 local6 local7)
property :input_parameters, Hash, default: {}
property :cookbook_source, String, default: 'rsyslog'
property :template_source, [String, nil]

default_action :create

action_class do
  include Rsyslog::Cookbook::Helpers
end

action :create do
  template_source = new_resource.template_source || labeled_template('file-input.conf.erb', new_resource.config_style)
  variables = {
    facility: new_resource.facility,
    file_name: new_resource.file,
    input_parameters: new_resource.input_parameters,
    severity: new_resource.severity,
    state_file: new_resource.config_style == 'legacy' ? new_resource.input_name : nil,
    tag: new_resource.input_name,
  }

  template ::File.join(rsyslog_config_dir, "#{new_resource.priority}-#{new_resource.input_name}.conf") do
    mode new_resource.config_file_mode
    owner new_resource.config_file_owner
    group new_resource.config_file_group
    source template_source
    cookbook new_resource.cookbook_source
    variables variables
    notifies :create, "template[#{::File.join(rsyslog_config_dir, '35-imfile.conf')}]", :before
  end
end

action :delete do
  file ::File.join(rsyslog_config_dir, "#{new_resource.priority}-#{new_resource.input_name}.conf") do
    action :delete
  end
end
