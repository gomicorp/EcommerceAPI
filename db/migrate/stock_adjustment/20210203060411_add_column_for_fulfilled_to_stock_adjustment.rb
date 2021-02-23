class AddColumnForFulfilledToStockAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_adjustments, :fulfilled, :boolean, default: false
  end
end
