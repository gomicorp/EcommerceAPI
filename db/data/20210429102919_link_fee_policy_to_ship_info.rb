class LinkFeePolicyToShipInfo < ActiveRecord::Migration[6.0]
  FEE_MAP = {
    th: {
      normal: ['normal', '-'],
      express: ['express', '-'],
      bulk_express: ['express', 'bulk']
    },
    vn: {
      normal: ['normal', 'downtown'],
      far: ['normal', 'suburb'],
      free: ['free', '-']
    },
    kr: {
      normal: ['normal', '-'],
      free: ['free', '-']
    }
  }.freeze

  def up
    Country.all.each do |country|
      national_fee_map = FEE_MAP.dig(country.short_name.to_sym)
      national_fee_map.keys.each do |type|
        ship_infos = ShipInfo.where(order_info: OrderInfo.where(country: country), ship_type: type.to_sym)
        next if ship_infos.empty?

        map_comp = national_fee_map.dig(type)
        fee = Policy::ShippingFee.where(delivery_type: map_comp.first.to_s, country: country, feature: map_comp.last.to_s, current: true).last
        ap fee
        ship_infos.update_all(fee_policy_id: fee.id)
      end
    end
  end

  def down
    Country.all.each do |country|
      national_fee_map = FEE_MAP.dig(country.short_name.to_sym)
      national_fee_map.keys.each do |type|
        map_comp = national_fee_map.dig(type)
        fee = Policy::ShippingFee.where(delivery_type: map_comp.first.to_s, country: country, feature: map_comp.last.to_s, current: true).last
        ship_infos = ShipInfo.where(fee_policy: fee)
        next if ship_infos.empty?

        ship_type = national_fee_map.select do |k,v|
          v.first == fee.delivery_type && v.last == fee.feature
        end.keys.first
        ship_infos.update_all(ship_type: ship_type)
      end
    end
  end
end
