# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog_client' do
  step_into :rsyslog_client, :rsyslog_service
  platform 'ubuntu', '24.04'

  context 'with server_ip and custom remote servers' do
    recipe do
      rsyslog_client 'default' do
        server_ip '10.0.0.50'
        custom_remote [
          { 'server' => '10.0.0.45', 'port' => 555, 'protocol' => 'udp', 'logs' => 'auth.*,mail.*' },
          { 'server' => '10.1.1.33', 'port' => 654, 'protocol' => 'tcp', 'logs' => 'authpriv.*,cron.*,daemon.*', 'remote_template' => 'RSYSLOG_SyslogProtocol23Format' },
        ]
      end
    end

    it { is_expected.to create_rsyslog_service('default') }
    it { is_expected.to create_template('/etc/rsyslog.d/49-remote.conf') }
    it { is_expected.to delete_file('/etc/rsyslog.d/35-server-per-host.conf') }

    it do
      is_expected.to render_file('/etc/rsyslog.d/49-remote.conf').with_content('*.* @@10.0.0.50:514')
      is_expected.to render_file('/etc/rsyslog.d/49-remote.conf').with_content('auth.*,mail.* @10.0.0.45:555')
      is_expected.to render_file('/etc/rsyslog.d/49-remote.conf').with_content('authpriv.*,cron.*,daemon.* @@10.1.1.33:654;RSYSLOG_SyslogProtocol23Format')
    end
  end

  context 'with relp enabled' do
    recipe do
      rsyslog_client 'default' do
        use_relp true
        server_ip '10.0.0.45'
        custom_remote [
          { 'server' => '10.1.1.33', 'remote_template' => 'RSYSLOG_SyslogProtocol23Format' },
        ]
      end
    end

    it { is_expected.to render_file('/etc/rsyslog.d/49-remote.conf').with_content('*.* :omrelp:10.0.0.45:20514') }
    it { is_expected.to render_file('/etc/rsyslog.d/49-remote.conf').with_content('*.* :omrelp:10.1.1.33:20514;RSYSLOG_SyslogProtocol23Format') }
  end

  context 'with invalid custom remote server' do
    recipe do
      rsyslog_client 'default' do
        custom_remote [{ 'port' => 555 }]
      end
    end

    it { expect { chef_run }.to raise_error(RuntimeError, /no IP/) }
  end
end
