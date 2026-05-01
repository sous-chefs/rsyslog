# frozen_string_literal: true

require 'spec_helper'

describe 'rsyslog_file_input' do
  step_into :rsyslog_file_input, :rsyslog_service
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      rsyslog_service 'default'

      rsyslog_file_input 'test-file' do
        file '/var/log/boot.log'
      end
    end

    it { is_expected.to create_template('/etc/rsyslog.d/99-test-file.conf') }

    it do
      is_expected.to render_file('/etc/rsyslog.d/99-test-file.conf').with_content('File="/var/log/boot.log"')
      is_expected.to render_file('/etc/rsyslog.d/99-test-file.conf').with_content('Tag="test-file:"')
    end
  end

  context 'with legacy config style' do
    recipe do
      rsyslog_service 'default' do
        config_style 'legacy'
      end

      rsyslog_file_input 'test-file' do
        file '/var/log/boot.log'
        config_style 'legacy'
      end
    end

    it { is_expected.to render_file('/etc/rsyslog.d/99-test-file.conf').with_content('$InputFileStateFile test-file') }
  end

  context 'delete action' do
    recipe do
      rsyslog_file_input 'test-file' do
        file '/var/log/boot.log'
        action :delete
      end
    end

    it { is_expected.to delete_file('/etc/rsyslog.d/99-test-file.conf') }
  end
end
