class CreateOrderConfirmations < ActiveRecord::Migration[6.0]
  def change
    create_table :order_confirmations do |t|
      t.references :order_info, foreign_key: true, null: false
      t.integer :contact_count
      t.text :memo

      t.timestamps
    end
  end
end
