# Cookbook:: rsyslog
# Resource:: file_input
#
# Copyright:: 2012-2017, Joseph Holsten
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
property :file, String, required: true
property :priority, Integer, default: 99
property :severity, String
property :facility, String
property :input_parameters, Hash, default: {}
property :cookbook_source, String, default: 'rsyslog'
property :template_source, String, default: lazy { labeled_template('file-input.conf.erb', node['rsyslog']['config_style']) }

unified_mode true

action :create do
  vars = {
    file_name: new_resource.file,
    tag: new_resource.name,
    severity: new_resource.severity,
    facility: new_resource.facility,
    input_parameters: new_resource.input_parameters,
  }
  vars['state_file'] = new_resource.name if node['rsyslog']['config_style'] == 'legacy'
  template "/etc/rsyslog.d/#{new_resource.priority}-#{new_resource.name}.conf" do
    mode '0664'
    owner node['rsyslog']['user']
    group node['rsyslog']['group']
    source new_resource.template_source
    cookbook new_resource.cookbook_source
    variables vars
    notifies :create, "template[#{node['rsyslog']['config_prefix']}/rsyslog.d/35-imfile.conf]", :before
  end
end
