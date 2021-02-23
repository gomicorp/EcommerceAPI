class AddIndexToExternalChannelCartItem < ActiveRecord::Migration[6.0]
  def change
    add_index :external_channel_cart_items, [:order_info_id, :product_option_id], name: 'order_info_product_option'
  end
end
