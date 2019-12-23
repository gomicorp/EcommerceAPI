class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :brand, foreign_key: true

      t.string :title
      t.integer :price, null: false, default: 0

      # counter cache
      t.integer :barcode_count, null: false, default: 0

      t.timestamps
    end
  end
end
