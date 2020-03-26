class AddReferenceToOptionBridge < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_option_bridges, :product_option, index: true
  end
end
