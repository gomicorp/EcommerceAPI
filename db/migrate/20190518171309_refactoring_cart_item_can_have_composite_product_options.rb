class RefactoringCartItemCanHaveCompositeProductOptions < ActiveRecord::Migration[5.2]
  def change
    modify_cart_items_reference
    modify_barcode_relation
  end

  private

  def modify_cart_items_reference
    # Change cart_item 're-connect' with product instead of product_option.
    remove_reference :cart_items, :product_option
    add_reference :cart_items, :product, foreign_key: true
  end

  def modify_barcode_relation
    barcode_has_many_product_options
    barcode_belongs_to_product
    update_barcode_counter_cache
  end

  def barcode_has_many_product_options
    # Make 'barcode' has many product_options instead of belongs to 'an' option
    remove_reference :barcodes, :product_option
    create_table :barcode_options do |t|
      t.references :barcode, foreign_key: true
      t.references :product_option, foreign_key: true

      t.timestamps
    end
  end

  def barcode_belongs_to_product
    add_reference :barcodes, :product, foreign_key: true
  end

  def update_barcode_counter_cache
    remove_column :product_options, :barcode_count
    # add_column :products, :barcode_count, :integer, null: false, default: 0
  end
end
