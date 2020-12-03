class AddCapturedShippingDatasetToCartItem < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :captured_seller_shipping, :boolean
    add_column :cart_items, :captured_seller_warehouse_key, :string
    add_column :cart_items, :captured_seller_warehouse_ship_fee, :integer
  end
end
