class CreatePolicyShippingFees < ActiveRecord::Migration[6.0]
  def change
    create_table :policy_shipping_fees do |t|
      t.string :delivery_type
      t.string :feature
      t.integer :fee
      t.references :country, null: false
      t.boolean :default, default: false
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
