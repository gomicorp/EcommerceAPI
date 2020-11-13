class AddCountryToInterestTag < ActiveRecord::Migration[6.0]
  def change
    add_reference :interest_tags, :country, foreign_key: true
  end
end
