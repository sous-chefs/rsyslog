require_relative './spec_helper'

describe service('rsyslogd') do
  it { should be_running }
end

describe package('rsyslog-relp') do
  it { should be_installed }
end
