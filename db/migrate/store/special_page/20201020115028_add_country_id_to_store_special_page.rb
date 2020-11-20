class AddCountryIdToStoreSpecialPage < ActiveRecord::Migration[6.0]
  def change
    add_reference :store_special_pages, :country, null: false, foreign_key: true
  end
end
