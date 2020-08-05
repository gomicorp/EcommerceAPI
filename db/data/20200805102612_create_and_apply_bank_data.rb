class CreateAndApplyBankData < ActiveRecord::Migration[6.0]
  def up
    Sellers::AccountInfo.all.each do |account|
      @bank = Bank.find_or_create_by(name: "shinhan", country: Country.ko)
      account.update bank_id: @bank.id
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
