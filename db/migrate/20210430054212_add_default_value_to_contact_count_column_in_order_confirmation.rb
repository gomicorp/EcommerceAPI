class AddDefaultValueToContactCountColumnInOrderConfirmation < ActiveRecord::Migration[6.0]
  def change
    change_column_default :order_confirmations, :contact_count, 0
  end
end
