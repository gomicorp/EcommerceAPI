class CreateHaravanOrderInfoOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :haravan_order_info_options do |t|
      t.references :haravan_order_info, null: false
      t.references :product_option, null: false

      t.timestamps
    end
  end
end
