class RanameEcOrderInfoIdInEcOrderInfoBrand < ActiveRecord::Migration[6.0]
  def change
    rename_column :external_channel_order_info_brands, :external_channel_order_info_id, :order_info_id
  end
end
