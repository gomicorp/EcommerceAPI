class CreateExternalChannelProductIds < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_product_ids do |t|
      t.references :channel, null: false
      t.references :product, null: false
      t.string :external_id, null: false

      t.timestamps
    end
  end
end
