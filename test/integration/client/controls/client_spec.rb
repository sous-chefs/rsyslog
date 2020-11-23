control 'client' do
  describe file '/etc/rsyslog.d/49-remote.conf' do
    its('content') { should match /^\$ActionQueueMaxDiskSpace 1G/ }
    its('content') { should match /@@10.0.0.50:514/ }
    its('content') { should match /auth\.\*,mail\.\* @10.0.0.45:555/ }
    its('content') { should match /authpriv\.\*,cron\.\*,daemon\.\* @@10.1.1.33:654/ }
  end
end
