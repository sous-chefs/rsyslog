require 'spec_helper'

describe 'rsyslog::client' do
  context "when node['rsyslog']['server_ip'] is not set" do
    before do
      Chef::Log.stub(:fatal)
      $stdout.stub(:puts)
    end

    it 'exists fatally' do
      expect { ChefSpec::ChefRunner.new.converge('rsyslog::client') }.to raise_error(SystemExit)
    end
  end

  let(:chef_run) do
    ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['rsyslog']['server_ip'] = '10.0.0.50'
    end.converge('rsyslog::client')
  end

  it 'includes the default recipe' do
    expect(chef_run).to include_recipe('rsyslog::default')
  end

  context '/etc/rsyslog.d/49-remote.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.d/49-remote.conf') }

    it 'creates the template' do
      expect(chef_run).to create_file_with_content('/etc/rsyslog.d/49-remote.conf', '*.* @@10.0.0.50:514')
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

  context '/etc/rsyslog.d/server.conf file' do
    let(:file) { chef_run.file('/etc/rsyslog.d/server.conf') }

    it 'deletes the file' do
      expect(chef_run).to delete_file('/etc/rsyslog.d/server.conf')
    end

    it 'notifies restarting the service' do
      expect(file).to notify('service[rsyslog]', :reload)
    end
  end
end
