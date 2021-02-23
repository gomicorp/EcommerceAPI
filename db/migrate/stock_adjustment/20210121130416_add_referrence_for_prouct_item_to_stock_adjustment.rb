# class AddReferrenceForProuctItemToStockAdjustment < ActiveRecord::Migration[6.0]
#   def change
#     add_reference :stock_adjustments, :product_item
#   end
# end
class AddReferrenceForProuctItemToStockAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_adjustments, :product_item_id, :bigint, default: 0
    ActiveRecord::Base.transaction do
      StockAdjustment.find_each do |adjustment|
        item_id = connection.execute("
                  SELECT product_item_id
                  from stock_adjustment_product_items
                  where stock_adjustment_id = #{adjustment.id}
                                     ").to_a.flatten.first
        unless item_id
          puts "Adjustment #[ #{adjustment.id} ] is dead. Kill dead adjustment!"
          adjustment.destroy!
          next
        end
        puts "Re-associate between adjustment #[ #{adjustment.id} ] and item #[ #{item_id} ]"
        adjustment.update!(product_item_id: item_id)
      end
    end
    change_column_null :stock_adjustments, :product_item_id, false
    add_foreign_key :stock_adjustments, :product_items
  end
end
