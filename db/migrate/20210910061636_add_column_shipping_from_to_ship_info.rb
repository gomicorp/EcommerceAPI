class AddColumnShippingFromToShipInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :ship_infos, :shipping_from, :string, null: true
  end
end
