# == Schema Information
#
# Table name: external_channel_tokens
#
#  id                        :bigint           not null, primary key
#  access_token              :text(65535)
#  access_token_expire_time  :datetime
#  auth_token                :text(65535)
#  auth_token_expire_time    :datetime
#  refresh_token             :text(65535)
#  refresh_token_expire_time :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  channel_id                :bigint           not null
#  country_id                :bigint           not null
#
# Indexes
#
#  index_external_channel_tokens_on_channel_id  (channel_id)
#  index_external_channel_tokens_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
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
