class AddCalculatedPriceColumnsToProductOptionBridge < ActiveRecord::Migration[6.0]
  def change
    add_column :product_option_bridges, :selling_price, :integer, null: false, default: 0

    ProductOptionBridge.without_callback(:save, :after, :after_save_propagation) do
      ProductOptionBridge.unscoped.all.each do |bridge|
        bridge.calculate_price_columns
        bridge.save
      end
    end
  end
end
