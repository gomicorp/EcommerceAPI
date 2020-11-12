class AddTrackingNumberAndCarrierCodeToShipInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :ship_infos, :tracking_number, :string, null: true
    add_column :ship_infos, :carrier_code, :string, null: true
  end
end
