require_relative './spec_helper'

describe service('rsyslog') do
  it { should be_running }
end

describe file('/etc/rsyslog.d/35-imfile.conf') do
  its(:content) { should match /imfile/ }
end

describe file('/etc/rsyslog.d/99-test-file.conf') do
  it { should exist }
  # Confirm that old behavior is corrected
  its(:content) { should_not match /\$ModLoad imfile/ }
  its(:content) { should match %r{/var/log/boot} }
  its(:content) { should match /test-file:/ }
end

# Include a second file to verify that configuration validates correctly
describe file('/etc/rsyslog.d/99-foo-log.conf') do
  it { should exist }
  # Confirm that old behavior is corrected
  its(:content) { should_not match /\$ModLoad imfile/ }
  its(:content) { should match %r{/var/log/foo\.log} }
  its(:content) { should match /foo-log:/ }
end
