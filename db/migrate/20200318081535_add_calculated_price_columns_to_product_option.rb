class AddCalculatedPriceColumnsToProductOption < ActiveRecord::Migration[6.0]
  def change
    add_column :product_options, :base_price, :integer, null: false, default: 0
    add_column :product_options, :discount_price, :integer, null: false, default: 0
    add_column :product_options, :price_change, :integer, null: false, default: 0
    add_column :product_options, :retail_price, :integer, null: false, default: 0

    ProductOption.unscoped.all.each do |product_option|
      product_option.callback_calculate_price_columns
      product_option.save
    end
  end
end
