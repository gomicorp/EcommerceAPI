class AddThirdSchemaToHaravanOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :haravan_order_infos, :order_number, :string
    add_column :haravan_order_infos, :cancelled_status, :string
  end
end
