class AddPostalCodeToShipInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :ship_infos, :postal_code, :string
  end
end
