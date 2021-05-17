class AddColumnForActiveToPolicyShippingFee < ActiveRecord::Migration[6.0]
  def change
    add_column :policy_shipping_fees, :active, :boolean, default: false
  end
end
