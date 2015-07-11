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
    def register_multi_user(token, users = [])
      # url = "#{@base_url}/users"
      # header = token_header(token)
      # params = users
      # uri, req = @http_client.post_request(url, params, header)
      # http_submit(uri, req)
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
