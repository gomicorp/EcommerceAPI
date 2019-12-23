class AddChargeIdToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :charge_id, :string
  end
end
