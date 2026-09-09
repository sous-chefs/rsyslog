# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog_service' do
  step_into :rsyslog_service
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      rsyslog_service 'default'
    end

    it { is_expected.to install_package('rsyslog') }
    it { is_expected.to create_directory('/etc/rsyslog.d').with(owner: 'root', group: 'root', mode: '0755') }
    it { is_expected.to create_directory('/var/spool/rsyslog').with(owner: 'syslog', group: 'adm', mode: '0700') }
    it { is_expected.to create_template('/etc/rsyslog.conf').with(owner: 'root', group: 'root', mode: '0644') }
    it { is_expected.to create_template('/etc/rsyslog.d/50-default.conf').with(owner: 'root', group: 'root', mode: '0644') }
    it { is_expected.to enable_systemd_unit('rsyslog.service') }
    it { is_expected.to start_systemd_unit('rsyslog.service') }

    it do
      is_expected.to render_file('/etc/rsyslog.conf').with_content(/^module\(load="imuxsock".*SysSock.Use=/)
      is_expected.to render_file('/etc/rsyslog.conf').with_content(/^module\(load="imklog"/)
      is_expected.to render_file('/etc/rsyslog.d/50-default.conf').with_content('*.emerg    :omusrmsg:*')
    end
  end

  context 'with relp enabled' do
    recipe do
      rsyslog_service 'default' do
        use_relp true
      end
    end

    it { is_expected.to install_package('rsyslog-relp') }
  end

  context 'with TLS enabled' do
    recipe do
      rsyslog_service 'default' do
        enable_tls true
        tls_ca_file '/etc/path/to/ssl-ca.crt'
      end
    end

    it { is_expected.to install_package('rsyslog-openssl') }
  end

  context 'with TLS and UDP' do
    recipe do
      rsyslog_service 'default' do
        enable_tls true
        tls_ca_file '/etc/path/to/ssl-ca.crt'
        protocol 'udp'
      end
    end

    it { expect { chef_run }.to raise_error(RuntimeError, /requires 'tcp'/) }
  end

  context 'on AlmaLinux' do
    platform 'almalinux', '9'

    recipe do
      rsyslog_service 'default'
    end

    it { is_expected.to create_directory('/var/lib/rsyslog') }
    it { is_expected.to render_file('/etc/rsyslog.conf').with_content(/^module\(load="imjournal".*StateFile=/) }
    it { is_expected.to render_file('/etc/rsyslog.d/50-default.conf').with_content('mail.*    -/var/log/maillog') }
  end

  context 'start action' do
    recipe do
      rsyslog_service 'default' do
        action :start
      end
    end

    it { is_expected.to start_systemd_unit('rsyslog.service') }
  end

  context 'stop action' do
    recipe do
      rsyslog_service 'default' do
        action :stop
      end
    end

    it { is_expected.to stop_systemd_unit('rsyslog.service') }
  end

  context 'restart action' do
    recipe do
      rsyslog_service 'default' do
        action :restart
      end
    end

    it { is_expected.to restart_systemd_unit('rsyslog.service') }
  end

  context 'reload action' do
    recipe do
      rsyslog_service 'default' do
        action :reload
      end
    end

    it { is_expected.to reload_systemd_unit('rsyslog.service') }
  end
end
