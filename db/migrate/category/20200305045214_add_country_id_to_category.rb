class AddCountryIdToCategory < ActiveRecord::Migration[6.0]
  def change
    add_reference :categories, :country, foreign_key: true
  end
end
