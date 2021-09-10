module ExternalChannel
  class Token < NationRecord
    belongs_to :channel

    def auth_token_expired?
      auth_token ? DateTime.now > auth_token_expire_time : true
    end

    def access_token_expired?
      access_token ? DateTime.now > access_token_expire_time : true
    end

    def refresh_token_expired?
      refresh_token ? DateTime.now > refresh_token_expire_time : true
    end
  end
end
