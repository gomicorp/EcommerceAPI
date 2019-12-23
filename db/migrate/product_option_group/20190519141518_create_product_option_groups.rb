class CreateProductOptionGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :product_option_groups do |t|
      t.references :product, foreign_key: true
      t.string :name
      t.boolean :is_required, null: false, default: true

      t.timestamps
    end
  end
end
