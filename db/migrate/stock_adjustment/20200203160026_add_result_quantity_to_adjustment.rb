class AddResultQuantityToAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_column :adjustments, :result_quantity, :integer, null: false, default: 0
  end
end
