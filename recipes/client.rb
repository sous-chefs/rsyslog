#
# Cookbook Name:: rsyslog
# Recipe:: client
#
# Copyright 2009-2013, Opscode, Inc.
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

include_recipe "rsyslog"

rsyslog_servers = []

if !node['rsyslog']['server'] and node['rsyslog']['server_ip'].nil? and Chef::Config[:solo]
  Chef::Log.fatal("Chef Solo does not support search, therefore it is a requirement of the rsyslog::client recipe that the attribute 'server_ip' is set when using Chef Solo. 'server_ip' is not set.")
elsif !node['rsyslog']['server']
  if node['rsyslog']['server_ip']
    # handle node['rsyslog']['server_ip'] being a string or an array
    rsyslog_servers = Array(node['rsyslog']['server_ip'])
  end

  # add all syslog servers to the syslog_servers array
  search(:node, node["rsyslog"]["server_search"]) do |result|
    syslog_servers << result['ipaddress']
  end

  if rsyslog_servers.empty?
    Chef::Application.fatal!("The rsyslog::client recipe was unable to determine the remote syslog server. Checked both the server_ip attribute and search()")
  end

  template "/etc/rsyslog.d/49-remote.conf" do
    only_if { node['rsyslog']['remote_logs'] && !rsyslog_servers.empty? }
    source "49-remote.conf.erb"
    backup false
    variables(
      :servers => rsyslog_servers,
      :protocol => node['rsyslog']['protocol'],
      :port => node['rsyslog']['port']
    )
    mode 0644
    notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  end

  file "/etc/rsyslog.d/server.conf" do
    action :delete
    notifies :reload, "service[#{node['rsyslog']['service_name']}]"
  end
end
