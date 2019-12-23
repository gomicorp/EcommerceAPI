class CreateProductAttributeProductItemGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :product_attribute_product_item_groups do |t|
      t.references :product_attribute, null: false, foreign_key: true, index: { name: 'index_p_attribute__p_item_group_on_p_attribute_id' }
      t.references :product_item_group, null: false, foreign_key: true, index: { name: 'index_p_item_group__p_attribute_on_p_item_group_id' }

      t.timestamps
    end
  end
end
