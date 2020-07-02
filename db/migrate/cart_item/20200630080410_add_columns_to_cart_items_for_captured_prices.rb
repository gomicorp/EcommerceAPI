class AddColumnsToCartItemsForCapturedPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :base_price, :integer, null: false, default: 0
    add_column :cart_items, :discount_price, :integer, null: false, default: 0
    add_column :cart_items, :additional_price, :integer, null: false, default: 0
    add_column :cart_items, :retail_price, :integer, null: false, default: 0
    add_column :cart_items, :price_change, :integer, null: false, default: 0
  end
end
