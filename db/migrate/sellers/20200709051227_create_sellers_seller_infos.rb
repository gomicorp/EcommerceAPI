class CreateSellersSellerInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_seller_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sellers_store_info, null: false, foreign_key: true
      t.references :sellers_account_info, null: false, foreign_key: true
      t.integer :cumulative_profit, default: 0
      t.integer :present_profit, default: 0
      t.integer :withdrawable_profit, default: 0
      t.references :sellers_grade, null: false, foreign_key: true

      t.timestamps
    end
  end
end
