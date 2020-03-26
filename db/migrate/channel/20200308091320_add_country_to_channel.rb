class AddCountryToChannel < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :country, foreign_key: true
  end
end
