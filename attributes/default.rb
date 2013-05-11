#
# Cookbook Name:: rsyslog
# Attributes:: default
#
# Copyright 2009, Opscode, Inc.
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

default["rsyslog"]["log_dir"]          = "/srv/rsyslog"
default["rsyslog"]["server"]           = false
default["rsyslog"]["protocol"]         = "tcp"
default["rsyslog"]["port"]             = 514
default["rsyslog"]["server_ip"]        = nil
default["rsyslog"]["server_search"]    = "role:loghost"
default["rsyslog"]["remote_logs"]      = true
default["rsyslog"]["per_host_dir"]     = "%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%"
default["rsyslog"]["max_message_size"] = "2k"
default["rsyslog"]["preserve_fqdn"]    = "off"

# TLS support
default["rsyslog"]["tls"] = false
default["rsyslog"]["tls_ca_file"] = nil
default["rsyslog"]["tls_certificate_file"] = nil
default["rsyslog"]["tls_key_file"] = nil
default["rsyslog"]["tls_authenticate_server"] = true
default["rsyslog"]["tls_authenticate_clients"] = true
default["rsyslog"]["tls_server_name"] = nil
default["rsyslog"]["tls_permitted_clients_names"] = nil

# The most likely platform-specific attributes
default["rsyslog"]["service_name"]     = "rsyslog"
default["rsyslog"]["service_spec"]     = nil
default["rsyslog"]["file_owner"]       = nil
default["rsyslog"]["file_group"]       = nil
default["rsyslog"]["dir_owner"]        = nil
default["rsyslog"]["dir_group"]        = nil
default["rsyslog"]["file_create_mode"] = "0640"
default["rsyslog"]["dir_create_mode"]  = "0755"
default["rsyslog"]["umask"] = "0022"
default["rsyslog"]["user"]  = "root"
default["rsyslog"]["group"] = "adm"
default["rsyslog"]["priv_seperation"] = false

case node["platform"]
when "ubuntu"
  # syslog user introduced with natty package
  if node['platform_version'].to_f < 10.10 then
    default["rsyslog"]["user"] = "syslog"
    default["rsyslog"]["group"] = "adm"
    default["rsyslog"]["priv_seperation"] = true
  else
    default["rsyslog"]["file_owner"] = "syslog"
    default["rsyslog"]["file_group"] = "adm"
    default["rsyslog"]["user"]  = "syslog"
    default["rsyslog"]["group"] = "syslog"
    default["rsyslog"]["priv_seperation"] = true
  end
when "debian"
  default["rsyslog"]["file_owner"] = "root"
  default["rsyslog"]["file_group"] = "adm"
  default["rsyslog"]["priv_seperation"] = false
when "arch"
  default["rsyslog"]["service_name"] = "rsyslogd"
end
