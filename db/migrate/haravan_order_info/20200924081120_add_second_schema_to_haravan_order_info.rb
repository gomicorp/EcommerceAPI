class AddSecondSchemaToHaravanOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :haravan_order_infos, :pay_method, :string
    add_column :haravan_order_infos, :channel, :string
    add_column :haravan_order_infos, :paid_at, :datetime
    add_column :haravan_order_infos, :order_status, :integer
    add_column :haravan_order_infos, :ship_fee, :integer
  end
end
