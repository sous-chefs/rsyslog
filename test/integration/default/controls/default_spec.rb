control 'service' do
  describe service 'rsyslog' do
    it { should be_running }
    it { should be_enabled }
  end
end

control 'default-conf' do
  describe file '/etc/rsyslog.d/50-default.conf' do
    its('content') { should match /(^(#|\$|:)|^$|(.+\..+)+)/ }
  end
end
