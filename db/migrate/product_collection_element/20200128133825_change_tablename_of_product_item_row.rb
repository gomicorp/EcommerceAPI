class ChangeTablenameOfProductItemRow < ActiveRecord::Migration[6.0]
  def change
    rename_table :product_item_rows, :product_collection_elements
  end
end
