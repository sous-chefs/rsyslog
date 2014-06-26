#
# Cookbook Name:: rsyslog
# Recipe:: postgresql
#
# Copyright 2009-2014, Opscode, Inc.
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

# Effectively unset this attribute. We would set it to nil but
# CHEF-4438 prevents that from working.
node.normal['rsyslog']['log_dir'] = false

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'
include_recipe 'rsyslog::server'

package 'rsyslog-pgsql' do
  package_name value_for_platform_family(
    'suse' => 'rsyslog-module-pgsql',
    'default' => 'rsyslog-pgsql'
  )

  # Gentoo and Arch don't have split packages.
  not_if { platform_family? 'gentoo', 'arch' }
end

# Generate a random password.
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
user = node['rsyslog']['user'] # Avoid false FC warning.
node.normal_unless['postgresql']['password'][user] = secure_password

pg_conn = {
  :host => 'localhost',
  :username => node['rsyslog']['user'],
  :password => node['postgresql']['password'][node['rsyslog']['user']]
}

postgresql_database_user pg_conn[:username] do
  connection :host => pg_conn[:host]
  password pg_conn[:password]
end

# The database creation statement is broken in all current versions
# and can't be executed in the query block below anyway. Details at
# https://github.com/rsyslog/rsyslog/pull/88. SQL_ASCII is the
# recommended encoding and template1 can't be used as a result.
postgresql_database 'Syslog' do
  connection :host => pg_conn[:host]
  owner pg_conn[:username]
  encoding 'SQL_ASCII'
  template 'template0'
end

postgresql_database 'Syslog-Schema' do
  database_name 'Syslog'
  connection pg_conn
  action :query

  # PostgreSQL didn't support CREATE TABLE IF NOT EXISTS until 9.1 so
  # use that only if available, otherwise ignore failures.
  supports_exists = node['postgresql']['version'].to_f >= 9.1
  ignore_failure !supports_exists

  sql do
    case node['platform_family']
    when 'suse'
      # Slightly different to the default.
      data = ::File.read '/usr/share/doc/packages/rsyslog/pgsql-createDB.sql'
    when 'debian'
      # Despite the odd filename, this really is createDB.sql.
      data = ::File.read '/usr/share/dbconfig-common/data/rsyslog-pgsql/install/pgsql'
    when 'rhel'
      # RHEL installs createDB.sql to a versioned location.
      data = ::File.read Dir.glob('/usr/share/doc/rsyslog-pgsql-*/createDB.sql').first
    when 'gentoo'
      # Gentoo installs createDB.sql to a versioned location like RHEL
      # does but also compresses it with bzip2 so an extra gem is needed.
      raise NotImplementedError, 'cannot execute createDB.sql on Gentoo yet'
    when 'arch'
      # Arch does not install the createDB.sql script at all!
      raise NotImplementedError, 'cannot execute createDB.sql on Arch yet'
    else
      # This location is the upstream default.
      data = ::File.read '/usr/share/doc/rsyslog-pgsql/createDB.sql'
    end

    # The database has already been created above.
    data.gsub!(/.*CREATE DATABASE.*/i, '')

    # The script also contains a backslash command that cannot be
    # executed in this query block and isn't needed anyway.
    data.gsub!(/^\\.*/, '')

    # Prevent this query from failing if the tables exist. See above.
    data.gsub!(/CREATE TABLE/i, '\0 IF NOT EXISTS') if supports_exists

    data
  end
end

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/35-postgresql.conf" do
  source   '35-postgresql.conf.erb'
  owner    'root'
  group    'root'
  mode     '0640'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  variables pg_conn
end
