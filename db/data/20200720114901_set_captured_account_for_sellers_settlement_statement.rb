class SetCapturedAccountForSellersSettlementStatement < ActiveRecord::Migration[6.0]
  def up
    transaction do
      Sellers::SettlementStatement.all.each do |statement|
        account = statement.seller_info.account_info
        captured_attribute = {
          captured_country: account.country,
          captured_bank: account.bank,
          captured_owner_name: account.owner_name,
          captured_account_number: account.account_number
        }
        statement.update(captured_attribute)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
