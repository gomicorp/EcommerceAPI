class AddCancelMessageToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :cancelled, :boolean, null: false, default: false
    add_column :payments, :cancel_message, :text
  end
end
