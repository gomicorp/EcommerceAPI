class AddBankReferenceToAccountInfo < ActiveRecord::Migration[6.0]
  def change
    add_reference :sellers_account_infos, :bank, foreign_key: true, null: true, index: true
  end
end
