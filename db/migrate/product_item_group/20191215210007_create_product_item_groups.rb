class CreateProductItemGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :product_item_groups do |t|
      t.references :brand, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
