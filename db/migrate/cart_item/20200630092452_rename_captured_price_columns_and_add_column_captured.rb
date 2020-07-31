class RenameCapturedPriceColumnsAndAddColumnCaptured < ActiveRecord::Migration[6.0]
  def change
    add_prefix_to_captured_price_columns

    add_column :cart_items, :captured, :boolean, null: false, default: false
  end

  private

  def add_prefix_to_captured_price_columns
    rename_column :cart_items, :base_price, :captured_base_price
    rename_column :cart_items, :discount_price, :captured_discount_price
    rename_column :cart_items, :additional_price, :captured_additional_price
    rename_column :cart_items, :retail_price, :captured_retail_price
    rename_column :cart_items, :price_change, :captured_price_change
  end
end
