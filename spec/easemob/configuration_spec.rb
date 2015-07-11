# encoding: UTF-8
require 'spec_helper'
require 'yaml'
require 'awesome_print'

describe Easemob::Configuration do
  before(:all) do
    EASEMOB_CONFIG = YAML.load(File.open(Easemob.root + '/config.yml')).symbolize_keys
    @deault_config = EASEMOB_CONFIG[:easemob].symbolize_keys
  end

  it 'should setup config' do
    Easemob.configure do |config|
      config.client_id = @deault_config[:client_id]
      config.client_secret = @deault_config[:client_secret]
      config.host = @deault_config[:host]
      config.org_name = @deault_config[:org_name]
      config.app_name = @deault_config[:app_name]
    end
    expect(Easemob.configuration.client_id).to eql(@deault_config[:client_id])
  end
end
