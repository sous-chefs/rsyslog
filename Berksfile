source ENV.fetch('SUPERMARKET', 'https://supermarket.chef.io')

metadata

group :integration do
  cookbook 'yum'
  cookbook 'apt'
  cookbook 'rsyslog_test', path: 'test/fixtures/rsyslog_test'
end
