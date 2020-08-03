class CreateSellersItemSoldPapers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_item_sold_papers do |t|
      t.references :item, null: false, foreign_key: { to_table: :cart_items }
      t.references :seller_info, null: false, foreign_key: { to_table: :sellers_seller_infos }
      t.boolean :paid, default: false
      t.datetime :paid_at
      t.integer :adjusted_profit, default: 0

      t.timestamps
    end
  end
end
