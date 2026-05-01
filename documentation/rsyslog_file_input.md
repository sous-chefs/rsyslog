# rsyslog_file_input

Configures an imfile input so rsyslog can read a local file and emit messages with a tag.

## Actions

| Action    | Description                             |
| --------- | --------------------------------------- |
| `:create` | Creates the file input config. Default. |
| `:delete` | Removes the file input config.          |

## Properties

| Property           | Type        | Default         | Description                        |
| ------------------ | ----------- | --------------- | ---------------------------------- |
| `input_name`       | String      | name property   | Input name and syslog tag.         |
| `file`             | String      | required        | File path to monitor.              |
| `priority`         | Integer     | `99`            | Config file prefix in `rsyslog.d`. |
| `severity`         | String, nil | `nil`           | Optional syslog severity.          |
| `facility`         | String, nil | `nil`           | Optional syslog facility.          |
| `input_parameters` | Hash        | `{}`            | Additional imfile parameters.      |
| `cookbook_source`  | String      | `'rsyslog'`     | Cookbook containing the template.  |
| `template_source`  | String, nil | labeled default | Template source override.          |

Also accepts shared path and ownership properties such as `config_prefix`, `config_file_owner`, `config_file_group`, and `config_file_mode`.

## Examples

```ruby
rsyslog_service 'default'

rsyslog_file_input 'app-log' do
  file '/var/log/app.log'
end
```

```ruby
rsyslog_file_input 'app-log' do
  file '/var/log/app.log'
  facility 'local0'
  severity 'info'
  input_parameters 'PersistStateInterval' => 100
end
```
