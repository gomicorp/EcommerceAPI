class AddDeletedAtToProductCollectionAndElement < ActiveRecord::Migration[6.0]
  def up
    add_column :product_collections, :deleted_at, :datetime
    add_index :product_collections, :deleted_at
    add_column :product_collection_elements, :deleted_at, :datetime
    add_index :product_collection_elements, :deleted_at
  end

  def down
    remove_index :product_collections, :deleted_at
    remove_column :product_collections, :deleted_at, :datetime
    remove_index :product_collection_elements, :deleted_at
    remove_column :product_collection_elements, :deleted_at, :datetime
  end
end
