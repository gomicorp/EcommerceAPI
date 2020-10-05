class CreateHaravanOrderInfoBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :haravan_order_info_brands do |t|
      t.references :haravan_order_info, null: false
      t.references :brand, null: false

      t.timestamps
    end
  end
end
