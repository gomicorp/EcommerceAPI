class RenameColumnBarcodeCountToEntityCountForProduct < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :barcode_count, :entity_count
  end
end
