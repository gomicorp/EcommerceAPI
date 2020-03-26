class AddCountryReferenceColumnToProductItemGroup < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_item_groups, :country, foreign_key: true, null: true
  end
end
