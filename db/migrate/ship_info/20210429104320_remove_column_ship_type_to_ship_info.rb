class RemoveColumnShipTypeToShipInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :ship_infos, :ship_type, :integer
  end
end
