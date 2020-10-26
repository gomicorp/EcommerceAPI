class CreateExternalChannelOrderInfoProductOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_order_info_product_options do |t|
      t.references :external_channel_order_info, null: false, index: { name: :order_info_index }
      t.references :product_option, null: false, index: { name: :product_option_index }

      t.timestamps
    end
  end
end
