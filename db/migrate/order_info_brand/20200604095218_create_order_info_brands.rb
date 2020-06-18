class CreateOrderInfoBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :order_info_brands do |t|
      t.references :order_info, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
