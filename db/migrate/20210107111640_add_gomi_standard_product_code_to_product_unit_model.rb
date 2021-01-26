class AddGomiStandardProductCodeToProductUnitModel < ActiveRecord::Migration[6.0]
  def change
    add_column :product_items, :gomi_standard_product_code, :string, limit: 15
    add_index :product_items, :gomi_standard_product_code, unique: true

    add_column :product_collections, :gomi_standard_product_code, :string, limit: 15
    add_index :product_collections, :gomi_standard_product_code, unique: true
  end
end
