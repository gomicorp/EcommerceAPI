class CreateProductOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_options do |t|
      t.references :product, foreign_key: true
      t.string :name
      t.integer :additional_price, null: false, default: 0

      # counter cache
      t.integer :barcode_count, null: false, default: 0

      t.timestamps
    end

    # Change cart_item connect with not product but product_option
    remove_reference :cart_items, :product
    add_reference :cart_items, :product_option, foreign_key: true

    # Change barcode connect with not product but product_option
    remove_reference :barcodes, :product
    add_reference :barcodes, :product_option, foreign_key: true
  end
end
