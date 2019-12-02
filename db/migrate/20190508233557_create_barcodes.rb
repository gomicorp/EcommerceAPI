class CreateBarcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :barcodes do |t|
      t.references :product, foreign_key: true
      t.references :cart_item, foreign_key: true

      t.timestamps
    end
  end
end
