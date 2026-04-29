# frozen_string_literal: true

apt_update

rsyslog_server 'default' do
  tcp_max_sessions 123
end
