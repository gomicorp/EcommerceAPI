class RemoveBankNameInAccountInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :sellers_account_infos, :bank
  end
end
