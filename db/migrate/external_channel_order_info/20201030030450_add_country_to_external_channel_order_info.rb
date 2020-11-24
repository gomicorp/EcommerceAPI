class AddCountryToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_reference :external_channel_order_infos, :country, foreign_key: true
  end
end
