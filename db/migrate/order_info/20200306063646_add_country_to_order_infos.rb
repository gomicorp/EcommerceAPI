class AddCountryToOrderInfos < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_infos, :country, foreign_key: true
  end
end
