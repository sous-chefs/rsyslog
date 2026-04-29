# rsyslog_client

Configures rsyslog to forward logs to remote syslog servers.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs/configures rsyslog and renders remote forwarding config. Default. |
| `:delete` | Removes client forwarding config and the base service artifacts. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `server_ip` | String, Array, nil | `nil` | Remote syslog host or hosts. |
| `server_search` | String, nil | `nil` | Chef search query for remote servers. |
| `remote_logs` | true, false | `true` | Whether to create forwarding config. |
| `custom_remote` | Array | `[]` | Remote server hashes with `server`, `port`, `logs`, `protocol`, and `remote_template`. |
| `use_local_ipv4` | true, false | `false` | Use cloud local IPv4 from search results. |

Also accepts the shared rsyslog configuration properties from `rsyslog_service`.

## Examples

```ruby
rsyslog_client 'default' do
  server_ip '10.0.0.50'
end
```

```ruby
rsyslog_client 'default' do
  custom_remote [
    { 'server' => '10.0.0.45', 'logs' => 'auth.*,mail.*', 'port' => 555, 'protocol' => 'udp' },
  ]
end
```
