class AddCalculatedPriceColumnsToProductCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :product_collections, :cost_price, :integer, null: false, default: 0
    add_column :product_collections, :selling_price, :integer, null: false, default: 0

    ProductCollection.without_callback(:save, :after, :after_save_propagation) do
      ProductCollection.unscoped.all.each do |collection|
        collection.calculate_price_columns
        collection.save
      end
    end
  end
end
