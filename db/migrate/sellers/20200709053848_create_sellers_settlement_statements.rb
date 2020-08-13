class CreateSellersSettlementStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_settlement_statements do |t|
      t.references :seller_info, null: false, foreign_key: { to_table: :sellers_seller_infos }
      t.integer :settlement_amount
      t.datetime :requested_at
      t.datetime :accepted_at
      t.string :status

      t.timestamps
    end
  end
end
