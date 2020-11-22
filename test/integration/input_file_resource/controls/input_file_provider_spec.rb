control 'input-file-resource' do
  describe file '/etc/rsyslog.d/99-test-file.conf' do
    it { should exist }
    its('content') { should match %r{InputFileName /var/log/boot} }
    its('content') { should match /InputFileTag test-file/ }
    its('content') { should match /InputFileStateFile test-file/ }
  end
end
