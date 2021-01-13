class AddAuthTokenToExternalChannelToken < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_tokens, :auth_token, :string
    add_column :external_channel_tokens, :auth_token_expire_time, :datetime
  end
end
