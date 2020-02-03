class AddMemoToAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_column :adjustments, :memo, :text
  end
end
