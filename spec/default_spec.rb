require 'spec_helper'

describe 'rsyslog::default' do
  let(:chef_run) do
    ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge('rsyslog::default')
  end

  it 'installs the rsyslog part' do
    expect(chef_run).to install_package('rsyslog')
  end

  context "when node['rsyslog']['relp'] is true" do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rsyslog']['use_relp'] = true
      end.converge('rsyslog::default')
    end

    it 'installs the rsyslog-relp package' do
      expect(chef_run).to install_package('rsyslog-relp')
    end
  end

  context '/etc/rsyslog.d directory' do
    let(:directory) { chef_run.directory('/etc/rsyslog.d') }

    it 'creates the directory' do
      expect(chef_run).to create_directory('/etc/rsyslog.d')
    end

    it 'is owned by root:root' do
      expect(directory.owner).to eq('root')
      expect(directory.group).to eq('root')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end
  end

  context '/var/spool/rsyslog directory' do
    let(:directory) { chef_run.directory('/var/spool/rsyslog') }

    it 'creates the directory' do
      expect(chef_run).to create_directory('/var/spool/rsyslog')
    end

    it 'is owned by root:root' do
      expect(directory.owner).to eq('root')
      expect(directory.group).to eq('root')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end
  end

  context '/etc/rsyslog.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.conf') }

    it 'creates the template' do
      expect(chef_run).to create_file_with_content('/etc/rsyslog.conf', 'Configuration file for rsyslog v3')
    end

    it 'is owned by root:root' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(template.mode).to eq('0644')
    end

    it 'notifies restarting the service' do
      expect(template).to notify('service[rsyslog]', :restart)
    end
  end

  context '/etc/rsyslog.d/50-default.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.d/50-default.conf') }

    it 'creates the template' do
      expect(chef_run).to create_file_with_content('/etc/rsyslog.d/50-default.conf', 'Default rules for rsyslog.')
    end

    it 'is owned by root:root' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(template.mode).to eq('0644')
    end

    it 'notifies restarting the service' do
      expect(template).to notify('service[rsyslog]', :restart)
    end
  end

  context 'syslog service' do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(platform: 'redhat', version: '5.8').converge('rsyslog::default')
    end

    it 'stops and starts the syslog service on REHL' do
      expect(chef_run).to stop_service('syslog')
      expect(chef_run).to disable_service('syslog')
    end
  end

  context 'rsyslog service' do
    it 'starts and enables the service' do
      expect(chef_run).to set_service_to_start_on_boot('rsyslog')
    end
  end
end
