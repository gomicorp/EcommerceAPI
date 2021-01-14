class AddReferenceToStockAdjustmentForStockReceipt < ActiveRecord::Migration[6.0]
  def change
    add_reference :stock_adjustments, :stock_receipt, foreign_key: true, null: true
  end
end
