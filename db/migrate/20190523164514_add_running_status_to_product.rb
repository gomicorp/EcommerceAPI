class AddRunningStatusToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :running_status, :integer, null: false, default: 0
  end
end
