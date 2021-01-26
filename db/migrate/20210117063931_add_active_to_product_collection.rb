class AddActiveToProductCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :product_collections, :active, :boolean, null: false, default: false
  end
end
