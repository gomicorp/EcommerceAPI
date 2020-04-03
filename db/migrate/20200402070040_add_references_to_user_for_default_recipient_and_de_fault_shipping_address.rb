class AddReferencesToUserForDefaultRecipientAndDeFaultShippingAddress < ActiveRecord::Migration[6.0]

  def up
    add_reference :users, :default_receiver, references: :receivers, index: true, null: true
    add_reference :users, :default_address, references: :shipping_addresses, index: true, null: true
  end

  def down
    remove_reference :users, :default_receiver
    remove_reference :users, :default_address
  end
end
