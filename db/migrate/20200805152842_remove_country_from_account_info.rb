class RemoveCountryFromAccountInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :sellers_account_infos, :country, :string
  end
end
