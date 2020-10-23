class CreateExternalChannelOrderInfoBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_order_info_brands do |t|
      t.references :external_channel_order_info, null: false, index: { name: :order_info_index }
      t.references :brand, null: false, index: { name: :brand_index }

      t.timestamps
    end
  end
end
