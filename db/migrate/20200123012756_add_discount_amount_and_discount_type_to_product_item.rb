class AddDiscountAmountAndDiscountTypeToProductOption < ActiveRecord::Migration[6.0]
  def change
    add_column :product_options, :discount_amount, :float, default: 0
    add_column :product_options, :discount_type, :integer, default: 0
  end
end
