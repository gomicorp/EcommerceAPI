class CreateStockReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_receipts do |t|
      t.string :type
      t.datetime :requested_at
      t.datetime :confirmed_at
      t.string :from
      t.references :country, null: true, foreign_key: true
      t.string :serial_number
      t.text :comment

      t.timestamps
    end
  end
end
