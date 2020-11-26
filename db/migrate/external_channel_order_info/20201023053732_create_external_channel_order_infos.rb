class CreateExternalChannelOrderInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :external_channel_order_infos do |t|
      t.integer :external_channel_order_id
      t.string :order_number
      t.string :channel
      t.datetime :ordered_at
      t.integer :total_price
      t.integer :ship_fee
      t.string :pay_method
      t.datetime :paid_at
      t.integer :order_status
      t.string :cancelled_status

      t.timestamps
    end
  end
end
