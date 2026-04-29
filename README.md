# rsyslog Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/rsyslog.svg)](https://supermarket.chef.io/cookbooks/rsyslog)
[![CI State](https://github.com/sous-chefs/rsyslog/workflows/ci/badge.svg)](https://github.com/sous-chefs/rsyslog/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures rsyslog with custom resources.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. Visit [sous-chefs.org](https://sous-chefs.org/) or join the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

Current Linux systemd platforms with distro rsyslog packages are supported. See [LIMITATIONS.md](LIMITATIONS.md) for platform and package notes.

### Chef

* Chef Infra Client 15.3+

## Breaking Migration

Recipes and node attributes have been removed. See [migration.md](migration.md) for examples that convert the old recipe API to resource declarations.

## Resources

* [rsyslog_service](documentation/rsyslog_service.md)
* [rsyslog_client](documentation/rsyslog_client.md)
* [rsyslog_server](documentation/rsyslog_server.md)
* [rsyslog_file_input](documentation/rsyslog_file_input.md)

## Usage

### Standalone Service

```ruby
rsyslog_service 'default'
```

### Forward Logs to a Remote Server

```ruby
rsyslog_client 'default' do
  server_ip '10.0.0.50'
end
```

### Receive Remote Logs

```ruby
rsyslog_server 'default' do
  protocol 'udptcp'
  port 514
end
```

### Monitor a Local File

```ruby
rsyslog_service 'default'

rsyslog_file_input 'app-log' do
  file '/var/log/app.log'
  facility 'local0'
  severity 'info'
end
```

## Contributors

This project exists thanks to all the people who [contribute](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false).

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
