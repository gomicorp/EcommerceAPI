class DropUserReceiverTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_receivers
  end
end
