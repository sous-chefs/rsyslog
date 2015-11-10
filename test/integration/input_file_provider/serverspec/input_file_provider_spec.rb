require_relative './spec_helper'

describe service('rsyslog') do
  it { should be_running }
end

describe file('/etc/rsyslog.d/99-test-file.conf') do
  it { should exist }
end

describe file('/etc/rsyslog.d/99-test-file.conf') do
  its(:content) { should match /InputFileName \/var\/log\/boot/ }
end
