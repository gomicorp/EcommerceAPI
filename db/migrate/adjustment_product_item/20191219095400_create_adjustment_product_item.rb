class CreateAdjustmentProductItem < ActiveRecord::Migration[6.0]
  def change
    create_table :adjustment_product_items do |t|
      t.references :adjustment, foreign_key: true
      t.references :product_item, foreign_key: true
      t.boolean :is_positive
      t.integer :quantity
    end
  end
end
