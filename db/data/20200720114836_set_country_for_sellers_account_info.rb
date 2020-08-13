class SetCountryForSellersAccountInfo < ActiveRecord::Migration[6.0]
  def up
    Sellers::AccountInfo.where(country: nil).update_all(country: 'global')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
