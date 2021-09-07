class AddNinjaVanToShippingCarrierPolicy < ActiveRecord::Migration[6.0]
  def up
    Policy::ShippingCarrier.create(code: 'ninjavan-vn', name: 'Ninja Van', url: 'https://www.ninjavan.co/vi-vn/tracking', trackable: true, country: Country.vn)
  end

  def down
    Policy::ShippingCarrier.where(code: 'ninjavan-vn').first.delete
  end
end
