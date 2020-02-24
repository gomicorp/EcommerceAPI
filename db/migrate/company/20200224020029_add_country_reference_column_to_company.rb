class AddCountryReferenceColumnToCompany < ActiveRecord::Migration[6.0]
  def change
    add_reference :companies, :country, foreign_key: true, null: true
  end
end
