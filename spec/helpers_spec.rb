# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe Rsyslog::Cookbook::Helpers do
  subject(:helper) do
    Class.new do
      include Rsyslog::Cookbook::Helpers

      attr_accessor :node

      def platform_family?(*families)
        families.include?(node['platform_family'])
      end

      def platform?(*platforms)
        platforms.include?(node['platform'])
      end
    end.new
  end

  before do
    helper.node = { 'platform' => 'ubuntu', 'platform_family' => 'debian' }
  end

  it 'labels legacy templates' do
    expect(helper.labeled_template('file-input.conf.erb', 'legacy')).to eq('file-input-legacy.conf.erb')
  end

  it 'leaves modern templates unchanged' do
    expect(helper.labeled_template('file-input.conf.erb', nil)).to eq('file-input.conf.erb')
  end

  it 'defaults RELP package to rsyslog-relp' do
    expect(helper.rsyslog_relp_package).to eq('rsyslog-relp')
  end
end
