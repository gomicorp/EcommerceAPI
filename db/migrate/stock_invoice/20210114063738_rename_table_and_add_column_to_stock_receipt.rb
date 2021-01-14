class RenameTableAndAddColumnToStockReceipt < ActiveRecord::Migration[6.0]
  def change
    rename_table :stock_receipts, :stock_invoices
    add_column :stock_invoices, :destination, :string
    rename_column :stock_adjustments, :stock_receipt_id, :stock_invoice_id
  end
end
