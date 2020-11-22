class AddOrderReferenceToExternalChannelCartItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_cart_items, :external_channel_order_info, foreign_key: true, index: {name: 'ec_cart_items_on_ec_order_info_id'}
  end
end
