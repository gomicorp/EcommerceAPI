class AddReferenceForCountryToCart < ActiveRecord::Migration[6.0]
  def change
    add_reference(:carts, :country, foreign_key: true) unless Cart.attribute_method?(:country)
  end
end
