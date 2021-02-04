class AddCountryReferenceColumnToAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_reference :adjustments, :country, foreign_key: true, null: true
  end
end
