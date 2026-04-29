# frozen_string_literal: true

apt_update

rsyslog_service 'default' do
  imfile_parameters 'PollingInterval' => 10
end

rsyslog_file_input 'test-file' do
  file '/var/log/boot.log'
end

rsyslog_file_input 'foo-log' do
  file '/var/log/foo.log'
end
