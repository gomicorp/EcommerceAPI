class AddIsoCodeColumnToCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :iso_code, :string
  end
end
