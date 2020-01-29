class ChangeReferenceNameOfProductCollectionElement < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_collection_elements, :product_item_container_id, :product_collection_id
  end
end
