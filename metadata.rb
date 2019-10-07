name              'rsyslog'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures rsyslog'
version           '6.0.7'

%w(ubuntu debian mint redhat centos amazon scientific oracle fedora zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/rsyslog'
issues_url 'https://github.com/chef-cookbooks/rsyslog/issues'
chef_version '>= 12.7'
