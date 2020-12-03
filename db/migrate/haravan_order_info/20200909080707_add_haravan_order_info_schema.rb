class AddHaravanOrderInfoSchema < ActiveRecord::Migration[6.0]
  def change
    add_column :haravan_order_infos, :ordered_at, :datetime
  end
end
