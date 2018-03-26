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
property :cookbook_source, String, default: 'rsyslog'
property :template_source, String, default: 'file-input.conf.erb'

action :create do
  log_name = new_resource.name
  template "/etc/rsyslog.d/#{new_resource.priority}-#{new_resource.name}.conf" do
    mode '0664'
    owner node['rsyslog']['user']
    group node['rsyslog']['group']
    source new_resource.template_source
    cookbook new_resource.cookbook_source
    variables 'file_name' => new_resource.file,
              'tag' => log_name,
              'state_file' => log_name,
              'severity' => new_resource.severity,
              'facility' => new_resource.facility
    notifies :restart, "service[#{node['rsyslog']['service_name']}]", :delayed
  end

  service node['rsyslog']['service_name'] do
    supports restart: true, status: true
    action [:enable, :start]
  end
end
