class AddCalculatedPriceColumnsToProductOption < ActiveRecord::Migration[6.0]
  def change
    add_column :product_options, :base_price, :integer, null: false, default: 0
    add_column :product_options, :discount_price, :integer, null: false, default: 0
    add_column :product_options, :price_change, :integer, null: false, default: 0
    add_column :product_options, :retail_price, :integer, null: false, default: 0
  end
end
