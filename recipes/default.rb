#
# Cookbook:: rsyslog
# Recipe:: default
#
# Copyright:: 2009-2019, Chef Software, Inc.
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
package node['rsyslog']['package_name']
package rsyslog_relp_package if node['rsyslog']['use_relp'] && !platform_family?('freebsd')

if node['rsyslog']['enable_tls']
  case node['rsyslog']['tls_driver']
  when 'gtls'
    package "#{node['rsyslog']['package_name']}-gnutls"
  when 'ossl'
    raise "#{node['rsyslog']['package_name']}-openssl is not available for CentOS 7 -- use gnutls instead (node['rsyslog']['tls_driver'] = 'gtls')" if platform_family?('rhel') && platform_version.to_i == 7

    package "#{node['rsyslog']['package_name']}-openssl"
  end
end

if node['rsyslog']['enable_tls'] && node['rsyslog']['tls_ca_file'] && node['rsyslog']['protocol'] != 'tcp'
  raise "Recipe rsyslog::default can not use 'enable_tls' with protocol '#{node['rsyslog']['protocol']}' (requires 'tcp')"
end

directory "#{node['rsyslog']['config_prefix']}/rsyslog.d" do
  owner node['rsyslog']['config_files']['owner']
  group node['rsyslog']['config_files']['group']
  mode  node['rsyslog']['config_dir']['mode']
end

directory node['rsyslog']['working_dir'] do
  owner node['rsyslog']['user']
  group node['rsyslog']['group']
  mode  node['rsyslog']['working_dir_mode']
  recursive true
end

execute 'validate_config' do
  command "rsyslogd -N 1 -f #{node['rsyslog']['config_prefix']}/rsyslog.conf"
  action  :nothing
end

# Our main stub which then does its own rsyslog-specific
# include of things in /etc/rsyslog.d/*
template "#{node['rsyslog']['config_prefix']}/rsyslog.conf" do
  source  'rsyslog.conf.erb'
  owner   node['rsyslog']['config_files']['owner']
  group   node['rsyslog']['config_files']['group']
  mode    node['rsyslog']['config_files']['mode']
  notifies :run, 'execute[validate_config]'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

# Include imfile module
template "#{node['rsyslog']['config_prefix']}/rsyslog.d/35-imfile.conf" do
  source    labeled_template('35-imfile.conf.erb', node['rsyslog']['config_style'])
  owner     node['rsyslog']['config_files']['owner']
  group     node['rsyslog']['config_files']['group']
  mode      node['rsyslog']['config_files']['mode']
  variables module_parameters: node['rsyslog']['imfile'] # Supported with Rainer script
  notifies  :run, 'execute[validate_config]'
  notifies  :restart, "service[#{node['rsyslog']['service_name']}]"
  action    :nothing
end

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/50-default.conf" do
  source  '50-default.conf.erb'
  owner   node['rsyslog']['config_files']['owner']
  group   node['rsyslog']['config_files']['group']
  mode    node['rsyslog']['config_files']['mode']
  notifies :run, 'execute[validate_config]'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  only_if { node['rsyslog']['default_conf_file'] }
end

if platform_family?('smartos', 'omnios')
  # syslog needs to be stopped before rsyslog can be started on SmartOS, OmniOS
  service 'system-log' do
    action :disable
  end
end

if platform_family?('omnios')
  # manage the SMF manifest on OmniOS
  template '/var/svc/manifest/system/rsyslogd.xml' do
    source 'omnios-manifest.xml.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[import rsyslog manifest]', :immediately
  end

  execute 'import rsyslog manifest' do
    action :nothing
    command 'svccfg import /var/svc/manifest/system/rsyslogd.xml'
    notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  end
end

service node['rsyslog']['service_name'] do
  supports restart: true, status: true
  action [:enable, :start]
end
