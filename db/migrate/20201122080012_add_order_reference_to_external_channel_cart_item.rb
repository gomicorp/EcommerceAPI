class AddOrderReferenceToExternalChannelCartItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_cart_items, :external_channel_order_info, foreign_key: true
  end
end
