class ChangeStringToTextForTokenType < ActiveRecord::Migration[6.0]
  def change
    change_column :external_channel_tokens, :access_token, :text
    change_column :external_channel_tokens, :auth_token, :text
    change_column :external_channel_tokens, :refresh_token, :text
  end
end
