class CreateProductAttributeOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :product_attribute_options do |t|
      t.references :product_attribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
