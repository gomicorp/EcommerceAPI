class CreateProductOptionBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :product_option_brands do |t|
      t.references :product_option, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
