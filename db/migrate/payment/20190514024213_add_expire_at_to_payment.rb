class AddExpireAtToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :expire_at, :datetime
  end
end
