apt_update

include_recipe 'rsyslog::default'

rsyslog_file_input 'test-file' do
  file '/var/log/boot'
end

rsyslog_file_input 'foo-log' do
  file '/var/log/foo.log'
end
