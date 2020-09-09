class CreateHaravanOrderInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :haravan_order_infos do |t|
      t.integer :haravan_order_id
      t.integer :total_price

      t.timestamps
    end
  end
end
