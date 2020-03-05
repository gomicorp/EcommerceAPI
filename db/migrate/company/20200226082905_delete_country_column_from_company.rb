class DeleteCountryColumnFromCompany < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :country_id
  end
end
