class AddCalculatedPriceColumnsToProductOptionBridge < ActiveRecord::Migration[6.0]
  def change
    add_column :product_option_bridges, :selling_price, :integer, null: false, default: 0
  end
end
