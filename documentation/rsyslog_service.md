# rsyslog_service

Installs rsyslog, renders the main configuration, manages default local logging, and controls the systemd service.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs, configures, enables, and starts rsyslog. Default. |
| `:delete` | Stops rsyslog and removes artifacts created by `:create`. |
| `:start` | Starts the systemd unit. |
| `:stop` | Stops the systemd unit. |
| `:restart` | Restarts the systemd unit. |
| `:reload` | Reloads the systemd unit. |

## Key Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `package_name` | String | `'rsyslog'` | Package to install. |
| `service_name` | String | platform default | Service name. |
| `config_prefix` | String | `'/etc'` | Prefix containing `rsyslog.conf` and `rsyslog.d`. |
| `working_dir` | String | platform default | Rsyslog work directory. |
| `protocol` | String | `'tcp'` | Listener protocol when `server true`. |
| `port` | Integer, String | `514` | Listener or forwarding port. |
| `use_relp` | true, false | `false` | Install RELP support package. |
| `enable_tls` | true, false | `false` | Install TLS support package and render TLS directives. |
| `modules` | Array | platform default | Modules loaded in `rsyslog.conf`. |
| `module_directives` | Hash | platform default | Module-specific parameters. |
| `default_facility_logs` | Hash | platform default | Facility-to-file rules for `50-default.conf`. |

All former `node['rsyslog']` defaults are available as explicit properties.

## Examples

```ruby
rsyslog_service 'default'
```

```ruby
rsyslog_service 'default' do
  max_message_size '4k'
  default_conf_file false
end
```
