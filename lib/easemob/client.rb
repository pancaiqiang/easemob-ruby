require_relative 'http_client'
require 'json'
require 'active_support/core_ext/hash/keys'

module Easemob
  class Client
    def initialize()
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
      res = @http_client.submit(uri, req)
      p res
      @access_token = JSON.parse(res.body)['access_token'] if res.is_a?(Net::HTTPSuccess)
    end

    def register_single_user(token, username, password, nickname = nil)
      url = "#{@base_url}/users"
      params = {
        username: username,
        password: password,
        nickname: nickname
      }
      uri, req = @http_client.post_request(url, params)
      res = @http_client.submit(uri, req)
      res_hash = JSON.parse res
      res_hash.kind_of?(Array) ? res_hash.map(&:deep_symbolize_keys!) : res_hash.deep_symbolize_keys!
    end
  end
end
