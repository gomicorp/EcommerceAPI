class ChangeTablenameOfProductItemContainer < ActiveRecord::Migration[6.0]
  def change
    rename_table :product_item_containers, :product_collections
  end
end
