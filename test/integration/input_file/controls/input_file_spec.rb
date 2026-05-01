# frozen_string_literal: true

include_controls 'default'

control 'input-file' do
  describe file '/etc/rsyslog.d/35-imfile.conf' do
    it { should be_file }
    its('content') { should match /imfile/ }
    its('content') { should match /PollingInterval="10"/ }
  end

  describe file '/etc/rsyslog.d/99-test-file.conf' do
    it { should be_file }
    its('content') { should_not match /\$ModLoad imfile/ }
    its('content') { should match %r{/var/log/boot\.log} }
    its('content') { should match /test-file:/ }
  end

  describe file '/etc/rsyslog.d/99-foo-log.conf' do
    it { should be_file }
    its('content') { should_not match /\$ModLoad imfile/ }
    its('content') { should match %r{/var/log/foo\.log} }
    its('content') { should match /foo-log:/ }
  end
end
