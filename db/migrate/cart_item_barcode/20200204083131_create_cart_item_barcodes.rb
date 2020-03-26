class CreateCartItemBarcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_item_barcodes do |t|
      t.references :cart_item, null: false, foreign_key: true
      t.references :product_item_barcode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
