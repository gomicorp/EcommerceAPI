class AddReferenceToShipInfoForFeePolicy < ActiveRecord::Migration[6.0]
  def change
    add_reference :ship_infos, :fee_policy,  foreign_key: {to_table: :policy_shipping_fees}
  end
end
