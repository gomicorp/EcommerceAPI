class CreatePolicyShippingCarriers < ActiveRecord::Migration[6.0]
  def change
    create_table :policy_shipping_carriers do |t|
      t.string :code
      t.string :name
      t.boolean :trackable
      t.string :url
      t.references :country, null: false

      t.timestamps
    end
  end
end
