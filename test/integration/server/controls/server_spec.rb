control 'server' do
  describe file '/etc/rsyslog.d/35-server-per-host.conf' do
    it { should be_file }
  end

  describe file '/etc/rsyslog.d/49-remote.conf' do
    it { should_not be_file }
  end
end
