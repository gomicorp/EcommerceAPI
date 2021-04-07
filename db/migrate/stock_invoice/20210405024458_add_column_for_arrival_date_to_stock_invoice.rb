class AddColumnForArrivalDateToStockInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_invoices, :will_arrive_at, :datetime
  end
end
