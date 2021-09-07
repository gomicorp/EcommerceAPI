class AddConstraintAtShippingCarrierPolicy < ActiveRecord::Migration[6.0]
  def up
    change_column :policy_shipping_carriers, :code, :string, null: false
    change_column :policy_shipping_carriers, :name, :string, null: false
    add_index :policy_shipping_carriers, :code, unique: true
  end

  def down
    change_column :policy_shipping_carriers, :code, :string, null: true
    change_column :policy_shipping_carriers, :name, :string, null: true
    remove_index :policy_shipping_carriers, :code
  end
end
