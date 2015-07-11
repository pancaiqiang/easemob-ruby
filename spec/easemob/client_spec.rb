# encoding: UTF-8
require 'spec_helper'
require 'yaml'
require 'awesome_print'

describe Easemob::Client do
  before(:all) do
    EASEMOB_CONFIG = YAML.load(File.open(Easemob.root + '/config.yml')).symbolize_keys
    @deault_config = EASEMOB_CONFIG[:easemob].symbolize_keys
    Easemob.configure do |config|
      config.client_id = @deault_config[:client_id]
      config.client_secret = @deault_config[:client_secret]
      config.host = @deault_config[:host]
      config.org_name = @deault_config[:org_name]
      config.app_name = @deault_config[:app_name]
    end
    @client = Easemob::Client.new
    @token_hash = @client.authorize
  end

  it 'should new a client' do
    expect(Easemob.configuration.client_id).to eql(@client.client_id)
  end

  it 'should get authorize token' do
    expect(@token_hash[:access_token].length).to eq(63)
    expect(@token_hash[:expires_in].to_s).to match(/\d+/)
  end

  # it 'should register_single_user' do
  #   res_hash = @client.register_single_user(@token_hash[:access_token], 'yangfusheng', '12345678', 'yang')
  #   expect(res_hash[:entities].length).to eq(1)
  #   expect(res_hash[:entities][:username]).to eq('yangfusheng')
  # end

  it 'should get_single_user' do
    res_hash = @client.get_single_user(@token_hash[:access_token], 'yangfusheng')
    expect(res_hash[:entities].length).to eq(1)
    expect(res_hash[:entities][0][:username]).to eq('yangfusheng')
  end

  it 'should get_multi_users' do
    res_hash = @client.get_multi_users(@token_hash[:access_token], 10)
    expect(res_hash[:entities].length).to be > 0
  end
end
