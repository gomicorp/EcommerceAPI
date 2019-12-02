class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.references :cart, foreign_key: true
      t.references :product, foreign_key: true

      # counter cache
      t.integer :barcode_count, null: false, default: 0

      t.timestamps
    end
  end
end
