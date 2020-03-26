class ColumnChangeOfProductOptionBridge < ActiveRecord::Migration[6.0]
  def change
    remove_column :product_option_bridges, :product_item_id
    remove_column :product_option_bridges, :product_option_id
    add_column :product_option_bridges, :connectable_id, :bigint
    add_column :product_option_bridges, :connectable_type, :string
  end
end

