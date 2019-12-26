class CreateProductItemProductOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :product_item_product_options do |t|
      t.references :product_item, null: false, foreign_key: true
      t.references :product_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
