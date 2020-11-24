class CreateExternalChannelTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_tokens do |t|
      t.references :country, null: false, foreign_key: true
      t.references :channel, null: false
      t.string :access_token
      t.datetime :access_token_expire_time
      t.string :refresh_token
      t.datetime :refresh_token_expire_time

      t.timestamps
    end
  end
end
