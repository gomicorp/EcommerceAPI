class RenameAdjustmentToStockAdjustment < ActiveRecord::Migration[6.0]
  def change
    rename_table :adjustments, :stock_adjustments
    rename_table :adjustment_product_items, :stock_adjustment_product_items
    rename_column :stock_adjustment_product_items, :adjustment_id, :stock_adjustment_id
  end
end
