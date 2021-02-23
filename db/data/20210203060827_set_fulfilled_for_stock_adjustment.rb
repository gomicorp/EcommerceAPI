class SetFulfilledForStockAdjustment < ActiveRecord::Migration[6.0]
  def up
    StockAdjustment.all.each do |adjustment|
      order = adjustment.order_info
      invoice = adjustment.stock_invoice
      if order
        puts "adjustment #[ #{adjustment.id} ] was fulfilled with order #[ #{order.id} ]" if adjustment.update!(fulfilled: true)
      elsif adjustment.stock_invoice
        result = adjustment.update!(fulfilled: true) if adjustment.stock_invoice.confirmed?
        puts "adjustment #[ #{adjustment.id} ] was fulfilled with invoice #[ #{invoice.id} ]" if result
      elsif !adjustment.order_info && !adjustment.stock_invoice
        puts "adjustment #[ #{adjustment.id} ] was fulfilled cause it's single adjustment." if adjustment.update!(fulfilled: true)
      end
    end
  end

  def down
    StockAdjustment.all.update_all(fulfilled: false)
  end
end
