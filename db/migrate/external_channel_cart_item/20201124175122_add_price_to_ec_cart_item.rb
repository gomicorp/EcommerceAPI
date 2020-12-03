class AddPriceToEcCartItem < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_cart_items, :unit_price, :integer
  end
end
