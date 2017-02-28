name              'rsyslog'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Installs and configures rsyslog'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '6.0.1'

recipe            'rsyslog', 'Sets up rsyslog for local logging'
recipe            'rsyslog::client', 'Sets up a client to log to a remote rsyslog server'
recipe            'rsyslog::server', 'Sets up an rsyslog server'

supports          'ubuntu', '>= 12.04'
supports          'debian', '>= 7.0'
supports          'redhat', '>= 5.0'
supports          'centos', '>= 5.0'
supports          'fedora'
supports          'scientific'
supports          'amazon'
supports          'oracle'

source_url 'https://github.com/chef-cookbooks/rsyslog'
issues_url 'https://github.com/chef-cookbooks/rsyslog/issues'
chef_version '>= 12.5'
