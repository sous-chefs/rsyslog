name              'rsyslog'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures rsyslog'
version           '7.0.1'

%w(ubuntu debian linuxmint redhat centos amazon scientific oracle fedora zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/rsyslog'
issues_url 'https://github.com/chef-cookbooks/rsyslog/issues'
chef_version '>= 13'
