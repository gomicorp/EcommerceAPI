class RenameProductItemBarcodeToProductItemEntity < ActiveRecord::Migration[6.0]
  def change
    rename_table :product_item_barcodes, :product_item_entities
    rename_table :cart_item_barcodes, :cart_item_entities
    rename_column :cart_item_entities, :product_item_barcode_id, :product_item_entity_id
    rename_column :cart_items, :barcode_count, :entity_count
    rename_column :product_items, :barcodes_count, :entities_count
    rename_column :product_items, :alive_barcodes_count, :alive_entities_count
  end
end
