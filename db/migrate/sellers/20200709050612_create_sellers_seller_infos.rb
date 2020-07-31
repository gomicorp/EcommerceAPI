class CreateSellersSellerInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_seller_infos do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.integer :cumulative_amount, default: 0
      t.integer :cumulative_profit, default: 0
      t.integer :present_profit, default: 0
      t.integer :withdrawable_profit, default: 0
      t.references :grade, null: false, foreign_key: { to_table: :sellers_grades }

      t.timestamps
    end
  end
end
