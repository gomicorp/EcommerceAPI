class CreateUserShippingAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_shipping_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shipping_address, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_shipping_addresses, [:user_id, :shipping_address_id], unique: true
  end
end
