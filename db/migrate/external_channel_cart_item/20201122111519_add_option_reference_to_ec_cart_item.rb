class AddOptionReferenceToEcCartItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_cart_items, :product_option
  end
end
