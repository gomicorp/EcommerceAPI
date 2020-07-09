class CreateSellersOrderSoldPapers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_order_sold_papers do |t|
      t.references :order_info, null: false, foreign_key: true
      t.references :sellers_seller_info, null: false, foreign_key: true
      t.integer :adjusted_profit, default: 0
      t.boolean :paid, default: false
      t.datetime :paid_at

      t.timestamps
    end
  end
end
