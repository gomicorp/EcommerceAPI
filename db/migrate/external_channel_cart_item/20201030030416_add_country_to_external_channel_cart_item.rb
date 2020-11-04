class AddCountryToExternalChannelCartItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_cart_items, :country, foreign_key: true
  end
end
