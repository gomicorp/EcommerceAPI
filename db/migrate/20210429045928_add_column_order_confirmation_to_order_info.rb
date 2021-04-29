class AddColumnOrderConfirmationToOrderInfo < ActiveRecord::Migration[6.0]
  def up
    add_column :order_infos, :order_confirmation_status, :string
  end

  def down
    remove_column :order_infos, :order_confirmation_status, :string
  end
end
