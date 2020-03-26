class ChangeNameToProductOptionBridge < ActiveRecord::Migration[6.0]
  def change
    rename_table :product_item_product_options, :product_option_bridges
  end
end
