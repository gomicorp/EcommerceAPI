class CreateProductItems < ActiveRecord::Migration[6.0]
  def change
    create_table :product_items do |t|
      t.references :item_group, null: false, foreign_key: { to_table: :product_item_groups }
      t.string :name
      t.string :serial_number
      t.integer :cost_price, null: false, default: 0
      t.integer :selling_price, null: false, default: 0

      t.timestamps
    end
  end
end
