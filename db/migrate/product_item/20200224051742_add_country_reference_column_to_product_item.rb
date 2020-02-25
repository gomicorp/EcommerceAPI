class AddCountryReferenceColumnToProductItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_items, :country, foreign_key: true, null: true
  end
end
