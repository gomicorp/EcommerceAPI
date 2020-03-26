class AddActiveToProductItem < ActiveRecord::Migration[6.0]
  def change
    add_column :product_items, :active, :boolean, null: false, default: false
  end
end
