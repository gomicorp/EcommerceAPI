class MigrateShippingFromForCurrentShipInfo < ActiveRecord::Migration[6.0]
  def up
    status_should_have_shipping_from = [:ship_ready, :ship_ing, :ship_complete]
    ship_infos_should_have_shipping_from = ShipInfo.where(current_status: ShipInfo::StatusLog.where(code: status_should_have_shipping_from))
    ship_infos_should_have_shipping_from.where(order_info: OrderInfo.where(country: Country.th)).update_all(shipping_from: ShipInfo::SHIPPING_FROM[:'TH-BK'])
    ship_infos_should_have_shipping_from.where(order_info: OrderInfo.where(country: Country.vn)).update_all(shipping_from: ShipInfo::SHIPPING_FROM[:'VN-HCM'])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
