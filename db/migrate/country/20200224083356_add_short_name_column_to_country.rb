class AddShortNameColumnToCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :short_name, :string
  end
end
