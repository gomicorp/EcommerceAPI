class CreateProductItemRows < ActiveRecord::Migration[6.0]
  def change
    create_table :product_item_rows do |t|
      t.references :product_item, null: false, foreign_key: true
      t.references :product_item_container, null: false, foreign_key: true
      t.integer :amount
      t.timestamps
    end
  end
end
