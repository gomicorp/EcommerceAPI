class MakeGomiStandardProductCodeNotNullCondition < ActiveRecord::Migration[6.0]
  def change
    change_column :product_items, :gomi_standard_product_code, :string, null: false
    change_column :product_collections, :gomi_standard_product_code, :string, null: false
  end
end
