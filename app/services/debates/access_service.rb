module Debates
  class AccessService
    def initialize(debate:)
      @debate = debate
    end

    def login
      User.create!(auth_token: fetch_auth_token)
    end

    private

    attr_reader :debate

    def fetch_auth_token
      debate.create_auth_token!
    end
  end
end
