class CreateSellersAccountInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_account_infos do |t|
      t.text :bank
      t.text :account_number
      t.text :owner_name

      t.timestamps
    end
  end
end
