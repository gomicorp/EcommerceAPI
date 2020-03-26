class AddAmountToAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_column :adjustments, :amount, :integer, null: false, default: 0
  end
end
