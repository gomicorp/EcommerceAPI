class AddColumnsToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :amount, :integer
    add_column :payments, :total_price_sum, :integer
    add_column :payments, :total_discount_amount, :integer
    add_column :payments, :delivery_amount, :integer
  end
end
