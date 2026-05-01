# frozen_string_literal: true

control 'service' do
  describe systemd_service 'rsyslog' do
    it { should be_running }
    it { should be_enabled }
  end
end

control 'default-conf' do
  describe file '/etc/rsyslog.d/50-default.conf' do
    it { should be_file }
    its('content') { should match /(^(#|\$|:)|^$|(.+\..+)+)/ }
  end
end
