class RemoveStockAdjustmentProductItem < ActiveRecord::Migration[6.0]
  def change
    drop_table :stock_adjustment_product_items
  end
end
