class AddCountryToExternalChannelProductId < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_product_ids, :country, foreign_key: true
  end
end
