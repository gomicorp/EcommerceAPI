class AddLeavedAtToProductItemBarcodes < ActiveRecord::Migration[6.0]
  def change
    add_column :product_item_barcodes, :leaved_at, :datetime, null: true
  end
end
