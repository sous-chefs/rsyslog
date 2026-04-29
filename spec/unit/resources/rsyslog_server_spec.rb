# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog_server' do
  step_into :rsyslog_server, :rsyslog_service
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      rsyslog_server 'default'
    end

    it { is_expected.to create_rsyslog_service('default').with(server: true) }
    it { is_expected.to create_directory('/srv/rsyslog').with(owner: 'syslog', group: 'adm', mode: '0755') }
    it { is_expected.to create_template('/etc/rsyslog.d/35-server-per-host.conf') }
    it { is_expected.to delete_file('/etc/rsyslog.d/49-remote.conf') }

    it do
      is_expected.to render_file('/etc/rsyslog.conf').with_content('input(type="imtcp" Port="514")')
      is_expected.to render_file('/etc/rsyslog.d/35-server-per-host.conf').with_content('/srv/rsyslog/%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%/auth.log')
    end
  end

  context 'with UDP and custom TCP sessions' do
    recipe do
      rsyslog_server 'default' do
        protocol 'udptcp'
        bind '127.0.0.1'
        port 5514
        tcp_max_sessions 123
      end
    end

    it do
      is_expected.to render_file('/etc/rsyslog.conf').with_content('MaxSessions="123"')
      is_expected.to render_file('/etc/rsyslog.conf').with_content('Address="127.0.0.1"')
      is_expected.to render_file('/etc/rsyslog.conf').with_content('Port="5514"')
    end
  end
end
