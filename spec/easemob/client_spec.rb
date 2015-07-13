# encoding: UTF-8
require 'spec_helper'
require 'yaml'
require 'awesome_print'
require 'time'

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
    @token = @token_hash[:access_token]
  end

  # ============================================================================
  ## 用户体系集成
  it 'should new a easemob ruby client' do
    expect(Easemob.configuration.client_id).to eql(@client.client_id)
  end

  it 'should get authorize token' do
    expect(@token.length).to eq(63)
    expect(@token_hash[:expires_in].to_s).to match(/\d+/)
  end

  it 'should register_single_user' do
  #   res_hash = @client.register_single_user(@token, 'yangfusheng', '12345678', 'yang')
  #   expect(res_hash[:entities].length).to eq(1)
  #   expect(res_hash[:entities][0][:username]).to eq('yangfusheng')
  end

  it 'should register_multi_users' do
  #   params = []
  #   1.upto(3).each do |i|
  #     user = {
  #       username: "yangfusheng#{i}",
  #       password: '12345678',
  #       nickname: "yang#{i}"
  #     }
  #     params << user
  #   end
  #   res_hash = @client.register_multi_users(@token, params)
  #   expect(res_hash[:entities].length).to eq(params.length)
  end

  it 'should get_single_user' do
    res_hash = @client.get_single_user(@token, 'yangfusheng')
    expect(res_hash[:entities].length).to eq(1)
    expect(res_hash[:entities][0][:username]).to eq('yangfusheng')
  end

  it 'should get_multi_users' do
    res_hash = @client.get_multi_users(@token, 10)
    expect(res_hash[:entities].length).to be > 0
  end

  it 'should del_single_user' do
  #   username = "#{rand(10)}del_single_user"
  #   res_hash = @client.register_single_user(@token, username, '12345678', username)
  #   expect(res_hash[:entities].length).to eq(1)
  #   expect(res_hash[:entities][0][:username]).to eq(username)
  #   sleep 5
  #   res_hash = @client.del_single_user(@token, username)
  #   expect(res_hash[:entities].length).to eq(1)
  #   expect(res_hash[:entities][0][:username]).to eq(username)
  end

  it 'should del_multi_users' do
  #   username = "#{rand(10)}del_multi_users"
  #   res_hash = @client.register_single_user(@token, username, '12345678', username)
  #   expect(res_hash[:entities].length).to eq(1)
  #   expect(res_hash[:entities][0][:username]).to eq(username)
  #   sleep 5
  #   res_hash = @client.del_multi_users(@token, 2)
  #   expect(res_hash[:entities].length).to eq(2)
  end

  it 'should reset_password' do
    res_hash = @client.reset_password(@token, 'yangfusheng', 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
  end

  it 'should reset_nickname' do
    res_hash = @client.reset_nickname(@token, 'yangfusheng', '杨浮生')
    expect(res_hash[:entities].length).to eq(1)
    expect(res_hash[:entities][0][:username]).to eq('yangfusheng')
    expect(res_hash[:entities][0][:nickname]).to eq('杨浮生')
  end

  # FIXME
  it 'should add_friend' do
    pending('should test add_friend later')
    fail
    # 0.upto(10).each do |i|
    #   res_hash = @client.del_single_user(@token, "#{i}add_friend")
    #   sleep 2
    # end
    # username = "#{rand(10)}add_friend"
    # res_hash = @client.register_single_user(@token, username, '12345678', username)
    # ap res_hash
    # expect(res_hash[:entities].length).to eq(1)
    # expect(res_hash[:entities][0][:username]).to eq(username)
    # sleep 5
    # res_hash = @client.add_friend(@token, 'yangfusheng', 'yangfusheng2')
    # ap res_hash
    # expect(res_hash[:entities].length).to eq(1)
    # expect(res_hash[:entities][0][:username]).to eq('yangfusheng2')
  end

  # FIXME
  it 'should del_friend' do
    pending('should test del_friend later')
    fail
  end

  it "should get user's friends" do
    res_hash = @client.friends(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
  end

  # FIXME
  it 'should add_blacks' do
    pending('should test add_blacks later')
    fail
  end

  it "should get user's black_list" do
    res_hash = @client.friends(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end

  # FIXME
  it 'should del_black' do
    pending('should test del_black later')
    fail
  end

  it "should get user's online_status" do
    res_hash = @client.online_status(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  it "should get user's offline_msg_count" do
    res_hash = @client.offline_msg_count(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  # FIXME
  it 'should someone offline_msg_status' do
    pending('should test offline_msg_status later')
    fail
  end

  it 'should deactivate_user' do
    res_hash = @client.deactivate_user(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:entities].kind_of?(Array)).to eq(true)
  end

  it 'should activate_user' do
    res_hash = @client.activate_user(@token, 'yangfusheng')
    expect(res_hash[:duration].to_s).to match(/\d+/)
  end

  # FIXME
  it 'should disconnect_user force' do
    pending('should test disconnect_user later')
    fail
  end

  # ============================================================================
  ## 聊天记录
  # FIXME
  it 'should export_chat_msgs' do
    pending('should test export_chat_msgs later')
    fail
  end

  # ============================================================================
  ## 群组管理
  it 'should get all groups' do
    res_hash = @client.groups(@token)
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
    expect(res_hash[:count].to_s).to match(/\d+/)
  end

  it 'should get groups_details' do
    res_hash = @client.groups_details(@token, [82251674197950872])
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end

  it 'should create_group' do
  #   # :groupid => "82251674197950872"
  #   group = {
  #     groupname: 'admin',  # 群组名称, 此属性为必须的
  #     desc: 'admin group for test',  # 群组描述, 此属性为必须的
  #     public: true,
  #     maxusers: 300,
  #     approval: true,
  #     owner: 'yangfusheng',  # 群组的管理员, 此属性为必须的
  #     members: ['yangfusheng2']
  #   }
  #   res_hash = @client.create_group(@token, group)
  #   expect(res_hash[:duration].to_s).to match(/\d+/)
  #   expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  it 'should update_group_info' do
    group_info = {
      description: "admin group for test, and already edit it at #{Time.now.to_i}"
    }
    res_hash = @client.update_group_info(@token, 82251674197950872, group_info)
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Hash)).to eq(true)
    expect(res_hash[:data][:description]).to eq(true)
  end

  it 'should del_group' do
    # group = {
    #   groupname: "test_group_#{rand(10)}",  # 群组名称, 此属性为必须的
    #   desc: 'test group for del',  # 群组描述, 此属性为必须的
    #   public: true,
    #   maxusers: 300,
    #   approval: true,
    #   owner: 'yangfusheng2',  # 群组的管理员, 此属性为必须的
    #   members: ['yangfusheng']
    # }
    # res_hash = @client.create_group(@token, group)
    # expect(res_hash[:duration].to_s).to match(/\d+/)
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
    # group_id = res_hash[:data][:groupid]
    # sleep 5
    # res_hash = @client.del_group(@token, group_id)
    # expect(res_hash[:duration].to_s).to match(/\d+/)
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
    # expect(res_hash[:data][:success]).to eq(true)
    # expect(res_hash[:data][:groupid]).to eq(group_id)
  end

  it 'should get all group_members' do
    res_hash = @client.group_members(@token, 82251674197950872)
    expect(res_hash[:duration].to_s).to match(/\d+/)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end

  # FIXME
  it 'should add_member to group' do
    pending('should test add_member later')
    fail
    # res_hash = @client.add_member(@token, 82251674197950872, 'yangfusheng3')
    # expect(res_hash[:duration].to_s).to match(/\d+/)
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  it 'should add_members to group' do
    # usernames = ['yangfusheng3']
    # res_hash = @client.add_members(@token, 82251674197950872, usernames)
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
    # expect(res_hash[:data][:groupid]).to eq('82251674197950872')
  end

  it 'should del_member from group' do
    # res_hash = @client.del_member(@token, 82251674197950872, 'yangfusheng3')
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
    # expect(res_hash[:data][:groupid]).to eq('82251674197950872')
  end

  it 'should get user_gropus' do
    res_hash = @client.user_gropus(@token, 'yangfusheng')
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end

  # ============================================================================
  ## 聊天室管理

  it 'should create_room' do
    # room = {
    #   name: 'test_chat_room',
    #   description: 'This is a chat room for test.',
    #   maxusers: 200,
    #   owner: 'yangfusheng'
    # }
    # # room_id = 82519548556738984
    # res_hash = @client.create_room(@token, room)
    # expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  it 'should update_room_info' do
    res_hash = @client.update_room_info(@token, 82519548556738984, { description: "This is a chat room for test, Edit it at #{Time.now.to_i}" })
    expect(res_hash[:data].kind_of?(Hash)).to eq(true)
  end

  it 'should del_room' do
    name = "test_chat_room_#{rand(10)}"
    room = {
      name: name,
      description: 'This is a chat room for test. Then del it.',
      maxusers: 200,
      owner: 'yangfusheng'
    }
    res_hash = @client.create_room(@token, room)
    room_id = res_hash[:data][:id]
    expect(res_hash[:data].kind_of?(Hash)).to eq(true)

    res_hash = @client.del_room(@token, room_id)
    expect(res_hash[:data][:success]).to eq(true)
  end

  it 'should get app rooms' do
    res_hash = @client.rooms(@token)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end

  it 'should get room_info' do
    res_hash = @client.room_info(@token, 82519548556738984)
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
    expect(res_hash[:data][0][:id]).to eq('82519548556738984')
  end

  it 'should get all user_rooms' do
    res_hash = @client.user_rooms(@token, 'yangfusheng')
    expect(res_hash[:data].kind_of?(Array)).to eq(true)
  end
end
