class AddUniqueIndexToProductCategories < ActiveRecord::Migration[6.0]
  def change
    add_index :product_categories, [:product_id, :category_id], unique: true
  end
end
