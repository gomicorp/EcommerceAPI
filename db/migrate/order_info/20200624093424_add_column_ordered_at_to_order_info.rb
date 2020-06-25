class AddColumnOrderedAtToOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :order_infos, :ordered_at, :datetime
  end
end
