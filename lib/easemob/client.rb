require_relative 'http_client'
require 'json'
require 'active_support/core_ext/hash/keys'

module Easemob
  class Client
    attr_reader :client_id, :client_secret, :host, :org_name, :app_name, :base_url
    def initialize
      @client_id = Easemob.configuration.client_id
      @client_secret = Easemob.configuration.client_secret
      @host = Easemob.configuration.host || 'https://a1.easemob.com'
      @org_name = Easemob.configuration.org_name
      @app_name = Easemob.configuration.app_name
      @http_client = HttpClient.new
      @base_url = "#{@host}/#{@org_name}/#{@app_name}"
    end

    # 登录并授权
    def authorize
      url = "#{@base_url}/token"
      params = {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_secret: @client_secret
      }
      uri, req = @http_client.post_request(url, params)
      http_submit(uri, req)
    end

    # 注册IM用户[单个]
    def register_single_user(token, username, password, nickname = nil)
      url = "#{@base_url}/users"
      header = token_header(token)
      params = {
        username: username,
        password: password,
        nickname: nickname
      }
      uri, req = @http_client.post_request(url, params, header)
      http_submit(uri, req)
    end

    # 注册IM用户[批量]
    def register_multi_users(token, users = [])
      url = "#{@base_url}/users"
      header = token_header(token)
      params = users
      uri, req = @http_client.post_request(url, params, header)
      http_submit(uri, req)
    end

    # 获取IM用户[单个]
    def get_single_user(token, username)
      url = "#{@base_url}/users/#{username}"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 获取IM用户[批量]
    def get_multi_users(token, limit = 10)
      url = "#{@base_url}/users"
      header = token_header(token)
      params = { limit: limit }
      uri, req = @http_client.get_request(url, params, header)
      http_submit(uri, req)
    end

    # 删除IM用户[单个]
    def del_single_user(token, username)
      url = "#{@base_url}/users/#{username}"
      header = token_header(token)
      uri, req = @http_client.del_request(url, nil, header)
      http_submit(uri, req)
    end

    # 删除IM用户[批量]
    def del_multi_users(token, limit = 2)
      url = "#{@base_url}/users"
      header = token_header(token)
      params = { limit: limit }
      uri, req = @http_client.del_request(url, params, header)
      http_submit(uri, req)
    end

    # 重置IM用户密码
    def reset_password(token, username, newpassword)
      url = "#{@base_url}/users/#{username}/password"
      header = token_header(token)
      params = { newpassword: newpassword }
      uri, req = @http_client.put_request(url, params, header)
      http_submit(uri, req)
    end

    # 修改用户昵称
    def reset_nickname(token, username, nickname)
      url = "#{@base_url}/users/#{username}"
      header = token_header(token)
      params = { nickname: nickname }
      uri, req = @http_client.put_request(url, params, header)
      http_submit(uri, req)
    end

    # 给IM用户的添加好友
    # FIXME
    def add_friend(token, owner_username, friend_username)
      url = "#{@base_url}/users/#{owner_username}/contacts/users/#{friend_username}"
      header = token_header(token)
      uri, req = @http_client.post_request(url, nil, header)
      http_submit(uri, req)
    end

    # 解除IM用户的好友关系
    def del_friend(token, owner_username, friend_username)
      url = "#{@base_url}/users/#{owner_username}/contacts/users/#{friend_username}"
      header = token_header(token)
      uri, req = @http_client.del_request(url, nil, header)
      http_submit(uri, req)
    end

    # 查看好友
    def friends(token, owner_username)
      url = "#{@base_url}/users/#{owner_username}/contacts/users"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 往IM用户的黑名单中加人
    def add_blacks(token, owner_username, usernames = [])
      url = "#{@base_url}/users/#{owner_username}/blocks/users"
      header = token_header(token)
      params = { usernames: usernames }
      uri, req = @http_client.post_request(url, params, header)
      http_submit(uri, req)
    end

    # 获取IM用户的黑名单
    def black_list(token, owner_username)
      url = "#{@base_url}/users/#{owner_username}/blocks/users"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 从IM用户的黑名单中减人
    def del_black(token, owner_username, blocked_username)
      url = "#{@base_url}/users/#{owner_username}/blocks/users/#{blocked_username}"
      header = token_header(token)
      uri, req = @http_client.del_request(url, nil, header)
      http_submit(uri, req)
    end

    # 查看用户在线状态
    def online_status(token, username)
      url = "#{@base_url}/users/#{username}/status"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 查询离线消息数
    def offline_msg_count(token, owner_username)
      url = "#{@base_url}/users/#{owner_username}/offline_msg_count"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 查询某条离线消息状态
    def offline_msg_status(token, username, msg_id)
      url = "#{@base_url}/users/#{username}/offline_msg_status/#{msg_id}"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    # 用户账号禁用
    def deactivate_user(token, username)
      url = "#{@base_url}/users/#{username}/deactivate"
      header = token_header(token)
      uri, req = @http_client.post_request(url, nil, header)
      http_submit(uri, req)
    end

    # 用户账号解禁
    def activate_user(token, username)
      url = "#{@base_url}/users/#{username}/activate"
      header = token_header(token)
      uri, req = @http_client.post_request(url, nil, header)
      http_submit(uri, req)
    end

    # 强制用户下线
    def disconnect_user(token, username)
      url = "#{@base_url}/users/#{username}/disconnect"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    ## 聊天记录

    # 导出聊天记录
    def export_chat_msgs(token, ql = nil, limit = nil, cursor = nil)
      url = "#{@base_url}/chatmessages"
      header = token_header(token)
      uri, req = @http_client.get_request(url, nil, header)
      http_submit(uri, req)
    end

    ## 图片语音文件上传、下载

    # 上传语音图片
    # 下载图片,语音文件
    # 下载缩略图

    ## 聊天相关API

    # 发送文本消息
    # 发送图片消息
    # ...

    ## 群组管理

    # 获取app中所有的群组
    # ...

    ## 聊天室管理

    # 创建聊天室
    # 修改聊天室信息
    # ...

    private

    def token_header(token)
      authorization = "Bearer " + token
      { 'Authorization' => authorization }
    end

    def http_submit(uri, req)
      res = @http_client.submit(uri, req)
      res_hash = JSON.parse res.body
      res_hash.kind_of?(Array) ? res_hash.map(&:deep_symbolize_keys!) : res_hash.deep_symbolize_keys!
    end
  end
end
