class AddDeletedAtToSeveralModels < ActiveRecord::Migration[6.0]
  def up
    add_column :product_items, :deleted_at, :datetime
    add_index :product_items, :deleted_at
    add_column :product_item_entities, :deleted_at, :datetime
    add_index :product_item_entities, :deleted_at
    add_column :product_option_bridges, :deleted_at, :datetime
    add_index :product_option_bridges, :deleted_at
    add_column :product_options, :deleted_at, :datetime
    add_index :product_options, :deleted_at
    add_column :product_option_brands, :deleted_at, :datetime
    add_index :product_option_brands, :deleted_at
  end

  def down
    remove_index :product_items, :deleted_at
    remove_column :product_items, :deleted_at, :datetime
    remove_index :product_item_entities, :deleted_at
    remove_column :product_item_entities, :deleted_at, :datetime
    remove_index :product_option_bridges, :deleted_at
    remove_column :product_option_bridges, :deleted_at, :datetime
    remove_index :product_options, :deleted_at
    remove_column :product_options, :deleted_at, :datetime
    remove_index :product_option_brands, :deleted_at
    remove_column :product_option_brands, :deleted_at, :datetime
  end
end
