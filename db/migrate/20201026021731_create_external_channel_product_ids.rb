class CreateExternalChannelProductIds < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_product_ids do |t|
      t.references :channel
      t.references :product
      t.string :external_id

      t.timestamps
    end
  end
end
