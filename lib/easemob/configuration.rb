module Easemob
  class Configuration
    attr_accessor :client_id, :client_secret, :host, :org_name, :app_name

    def initialize
      self.client_id = nil
      self.client_secret = nil
      self.host = nil
      self.org_name = nil
      self.app_name = nil
    end
  end
end
