class AddReferenceToStockAdjustmentForStockInvoice < ActiveRecord::Migration[6.0]
  def change
    add_reference :stock_adjustments, :stock_invoice, foreign_key: true, null: true
  end
end
