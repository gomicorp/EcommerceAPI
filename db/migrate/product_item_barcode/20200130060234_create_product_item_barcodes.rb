class CreateProductItemBarcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :product_item_barcodes do |t|
      t.references :product_item, null: false, foreign_key: true
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
