class AddCountryToBrand < ActiveRecord::Migration[6.0]
  def change
    add_reference :brands, :country, foreign_key: true
  end
end
