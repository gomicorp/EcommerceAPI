class AddCalculatedPriceColumnsToProductOptionBridge < ActiveRecord::Migration[6.0]
  def change
    add_column :product_option_bridges, :selling_price, :integer, null: false, default: 0

    ProductOptionBridge.unscoped.all.each do |bridge|
      bridge.callback_calculate_price_columns
      bridge.save
    end
  end
end
