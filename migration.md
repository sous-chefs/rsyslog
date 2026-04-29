# Migration Guide

## Breaking Change

This release removes the recipe and node attribute API. The cookbook now exposes only custom resources.

Removed APIs:

* `recipe[rsyslog::default]`
* `recipe[rsyslog::client]`
* `recipe[rsyslog::server]`
* `attributes/default.rb`
* `node['rsyslog'][...]` configuration

Use resource properties instead of node attributes.

## Recipe Mapping

### Default Recipe

Before:

```ruby
run_list 'recipe[rsyslog::default]'
```

After:

```ruby
rsyslog_service 'default'
```

### Client Recipe

Before:

```ruby
node.default['rsyslog']['server_ip'] = '10.0.0.50'
run_list 'recipe[rsyslog::client]'
```

After:

```ruby
rsyslog_client 'default' do
  server_ip '10.0.0.50'
end
```

### Server Recipe

Before:

```ruby
node.default['rsyslog']['tcp_max_sessions'] = 123
run_list 'recipe[rsyslog::server]'
```

After:

```ruby
rsyslog_server 'default' do
  tcp_max_sessions 123
end
```

### File Input Resource

Before and after:

```ruby
rsyslog_service 'default'

rsyslog_file_input 'app-log' do
  file '/var/log/app.log'
end
```

The file input resource now has explicit ownership and config path properties. It no longer reads `node['rsyslog']`.

## Chef Search

`rsyslog_client` no longer searches by default. Set `server_search` explicitly when Chef Server search is required:

```ruby
rsyslog_client 'default' do
  server_search 'role:loghost'
end
```

Direct `server_ip` configuration is preferred for local mode, Policyfiles, and tests.

## Test Cookbook Examples

Working examples live in `test/cookbooks/test/recipes/`:

* `default.rb`
* `client.rb`
* `server.rb`
* `relp.rb`
* `input_file.rb`
