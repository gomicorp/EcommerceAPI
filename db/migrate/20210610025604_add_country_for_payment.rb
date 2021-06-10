class AddCountryForPayment < ActiveRecord::Migration[6.0]
  def change
    add_reference :payments, :country, foreign_key: true
  end
end
