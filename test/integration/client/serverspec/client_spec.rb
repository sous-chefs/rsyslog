require_relative './spec_helper'

describe service('rsyslog') do
  it { should be_running }
end

describe file('/etc/rsyslog.d/35-server-per-host.conf') do
  it { should_not be_file }
end

describe file('/etc/rsyslog.d/49-remote.conf') do
  it { should be_file }
  its(:content) { should match "@@10.0.0.50:514" }
  its(:content) { should match /^\$ActionQueueMaxDiskSpace 1G/ }
  its(:content) { should match /authpriv\.\*,cron\.\*,daemon\.\* @@10\.1\.1\.33:654/ }
  its(:content) { should match /auth\.\*,mail\.\* @10.0.0.45:555/ }
end
