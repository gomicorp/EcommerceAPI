class CreateShippingAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_addresses do |t|
      t.string :loc_state
      t.string :loc_city
      t.string :loc_district
      t.string :loc_detail
      t.string :postal_code

      t.timestamps
    end
  end
end
