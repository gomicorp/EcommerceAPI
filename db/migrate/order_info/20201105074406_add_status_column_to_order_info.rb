class AddStatusColumnToOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :order_infos, :status, :string
    add_column :order_infos, :shipping_status, :string
    add_column :order_infos, :payment_status, :string
  end
end
