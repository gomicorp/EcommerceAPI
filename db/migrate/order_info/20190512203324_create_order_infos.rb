class CreateOrderInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :order_infos do |t|
      t.boolean :finished
      t.datetime :ordered_at

      t.timestamps
    end
  end
end
