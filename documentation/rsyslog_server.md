# rsyslog_server

Configures an rsyslog server that receives remote logs and writes per-host log files.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs/configures rsyslog as a server and renders per-host config. Default. |
| `:delete` | Removes server config, log directory, and base service artifacts. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `log_dir` | String | `'/srv/rsyslog'` | Root directory for received logs. |
| `per_host_dir` | String | `'%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%'` | Per-host path template. |
| `allow_non_local` | true, false | `false` | Whether non-local messages continue to lower-numbered rules. |
| `server_per_host_template` | String | `'35-server-per-host.conf.erb'` | Template source for per-host config. |
| `server_per_host_cookbook` | String | `'rsyslog'` | Cookbook containing the per-host template. |

Also accepts the shared rsyslog configuration properties from `rsyslog_service`.

## Examples

```ruby
rsyslog_server 'default'
```

```ruby
rsyslog_server 'default' do
  protocol 'udptcp'
  port 5514
  tcp_max_sessions 500
  per_host_dir '%HOSTNAME%'
end
```
