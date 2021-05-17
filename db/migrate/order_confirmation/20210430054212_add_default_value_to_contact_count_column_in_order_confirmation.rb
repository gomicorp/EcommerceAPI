class AddDefaultValueToContactCountColumnInOrderConfirmation < ActiveRecord::Migration[6.0]
  def up
    change_column_default :order_confirmations, :contact_count, 0
  end

  def down
    change_column_default :order_confirmations, :contact_count, nil
  end
end
