class AddColumnToOrderInfoExpiredAt < ActiveRecord::Migration[6.0]
  def up
    add_column :order_infos, :expired_at, :datetime
  end

  def down
    remove_column :order_infos, :expired_at, :datetime
  end
end
