class AddColumnsToSettlementStatementForCapturedAccountAndCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_settlement_statements, :captured_country, :string, null: false, default: 'global'
    add_column :sellers_settlement_statements, :captured_bank, :text, null: false
    add_column :sellers_settlement_statements, :captured_owner_name, :text, null: false
    add_column :sellers_settlement_statements, :captured_account_number, :text, null: false
  end
end
