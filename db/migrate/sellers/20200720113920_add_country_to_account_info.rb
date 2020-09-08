class AddCountryToAccountInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers_account_infos, :country, :string, null: false, default: 'global'
  end
end
