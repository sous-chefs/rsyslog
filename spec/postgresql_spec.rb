require 'spec_helper'

describe 'rsyslog::postgresql' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['rsyslog']['postgresql'] = false
      node.set['postgresql']['password']['postgres'] = 'secret' # Chef Solo workaround.
    end.converge(described_recipe)
  end

  let(:service_resource) { 'service[rsyslog]' }

  it "sets node['rsyslog']['server'] to true" do
    expect(chef_run.node['rsyslog']['server']).to be_true
  end

  it 'includes the default recipe' do
    expect(chef_run).to include_recipe('rsyslog::default')
  end

  it 'includes the server recipe' do
    expect(chef_run).to include_recipe('rsyslog::server')
  end

  it 'includes the postgresql::server recipe' do
    expect(chef_run).to include_recipe('postgresql::server')
  end

  it 'installs the rsyslog-pgsql package' do
    expect(chef_run).to install_package('rsyslog-pgsql')
  end

  it "sets node.normal['rsyslog']['log_dir'] to false" do
    expect(chef_run.node['rsyslog']['log_dir']).to be_false
  end

  it 'does not create the /srv/rsyslog directory' do
    expect(chef_run).not_to create_directory('/srv/rsyslog')
  end

  context '/etc/rsyslog.d/35-postgresql.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.d/35-postgresql.conf') }

    it 'creates the template' do
      expect(chef_run).to render_file(template.path).with_content('$ModLoad ompgsql')
    end

    it 'is owned by root:root' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0640 permissions' do
      expect(template.mode).to eq('0640')
    end

    it 'notifies restarting the service' do
      expect(template).to notify(service_resource).to(:restart)
    end
  end

  context '/etc/rsyslog.d/35-server-per-host.conf template' do
    let(:file) { chef_run.template('/etc/rsyslog.d/35-server-per-host.conf') }

    it 'deletes the file' do
      pending 'Stubbing class methods without breaking everything is hard'
      expect(chef_run).to delete_file(file.path)
    end

    it 'notifies restarting the service' do
      expect(file).to notify(service_resource).to(:restart)
    end
  end

  context '/etc/rsyslog.d/remote.conf file' do
    let(:file) { chef_run.file('/etc/rsyslog.d/remote.conf') }

    it 'deletes the file' do
      pending 'Stubbing class methods without breaking everything is hard'
      expect(chef_run).to delete_file(file.path)
    end

    it 'notifies reloading the service' do
      expect(file).to notify(service_resource).to(:reload)
    end
  end

  context 'database user' do
    it 'is created' do
      expect(chef_run).to create_postgresql_database_user('syslog')
    end
  end

  context 'Syslog database' do
    it 'is created' do
      expect(chef_run).to create_postgresql_database('Syslog')
    end

    it 'is populated' do
      expect(chef_run).to query_postgresql_database('Syslog-Schema')
    end
  end
end
