class AddReferenceForCountryToCart < ActiveRecord::Migration[6.0]
  def change
    add_reference :carts, :country, foreign_key: true
  end
end
