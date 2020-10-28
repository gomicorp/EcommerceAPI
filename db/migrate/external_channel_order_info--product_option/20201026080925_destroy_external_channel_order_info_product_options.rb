class DestroyExternalChannelOrderInfoProductOptions < ActiveRecord::Migration[6.0]
  def change
    drop_table :external_channel_order_info_product_options
  end
end
