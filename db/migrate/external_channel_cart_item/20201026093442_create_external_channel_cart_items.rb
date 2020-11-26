class CreateExternalChannelCartItems < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_cart_items do |t|
      t.string :external_option_id, null: false
      t.integer :option_count, null: false

      t.timestamps
    end
  end
end
