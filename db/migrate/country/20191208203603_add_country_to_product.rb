class AddCountryToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :country, foreign_key: true
  end
end
