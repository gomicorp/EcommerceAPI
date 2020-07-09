class CreateSellersSettlementStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_settlement_statements do |t|
      t.references :sellers_seller_info, null: false, foreign_key: true
      t.integer :settlement_amount
      t.datetime :requested_at
      t.datetime :accepted_at
      t.string :status

      t.timestamps
    end
  end
end
