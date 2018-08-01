name              'rsyslog'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures rsyslog'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '6.0.7'

recipe            'rsyslog', 'Sets up rsyslog for local logging'
recipe            'rsyslog::client', 'Sets up a client to log to a remote rsyslog server'
recipe            'rsyslog::server', 'Sets up an rsyslog server'

%w(ubuntu debian mint redhat centos amazon scientific oracle fedora zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/rsyslog'
issues_url 'https://github.com/chef-cookbooks/rsyslog/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
