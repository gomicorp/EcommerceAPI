class AddDeletedAtToProductItemGroupsAndMore < ActiveRecord::Migration[6.0]
  def up
    add_column :product_item_groups, :deleted_at, :datetime
    add_index :product_item_groups, :deleted_at
    add_column :product_attribute_product_item_groups, :deleted_at, :datetime
    add_index :product_attribute_product_item_groups, :deleted_at
    add_column :product_attributes, :deleted_at, :datetime
    add_index :product_attributes, :deleted_at
    add_column :product_attribute_options, :deleted_at, :datetime
    add_index :product_attribute_options, :deleted_at
  end

  def down
    remove_index :product_item_groups, :deleted_at
    remove_column :product_item_groups, :deleted_at, :datetime
    remove_index :product_attribute_product_item_groups, :deleted_at
    remove_column :product_attribute_product_item_groups, :deleted_at, :datetime
    remove_index :product_attributes, :deleted_at
    remove_column :product_attributes, :deleted_at, :datetime
    remove_index :product_attribute_options, :deleted_at
    remove_column :product_attribute_options, :deleted_at, :datetime
  end
end
