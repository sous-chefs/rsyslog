# frozen_string_literal: true

apt_update

rsyslog_client 'default' do
  server_ip '10.0.0.50'
  custom_remote [
    { 'server' => '10.0.0.45', 'logs' => 'auth.*,mail.*', 'port' => 555, 'protocol' => 'udp' },
    { 'server' => '10.1.1.33', 'logs' => 'authpriv.*,cron.*,daemon.*', 'port' => 654, 'protocol' => 'tcp', 'remote_template' => 'RSYSLOG_SyslogProtocol23Format' },
  ]
end
