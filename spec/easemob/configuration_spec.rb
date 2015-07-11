# encoding: UTF-8
require 'spec_helper'

describe WxExt::WeiXin do
  before(:all) do
    @weixin = WxExt::WeiXin.new '', ''
  end

  it 'should login to the mp' do
    res_hash = @weixin.login
    expect(res_hash[:status]).to eql(0)
  end
end
