class SetInitialDataForShippingCarrierPolicy < ActiveRecord::Migration[6.0]
  def up
    th_carriers = {
      alphafast: { name: 'Alpha Fast', url: 'https://www.alphafast.com/track', trackable: true },
      '800bestex': { name: 'Best Express', url: 'https://www.best-inc.co.th/track', trackable: true },
      'cj-korea-thai': { name: 'CJ Express', url: 'https://standardexpress.online/cj-logistics/', trackable: true },
      flash_express: { name: 'Flash express', url: 'https://www.flashexpress.co.th/tracking/', trackable: false },
      'j&t_express': { name: 'J&T express', url: 'https://www.jtexpress.co.th/index/query/gzquery', trackable: false },
      'kerry-logistics': { name: 'Kerry Express', url: 'https://th.kerryexpress.com/th/track/', trackable: true },
      'ninjavan-thai': { name: 'Ninja Van', url: 'https://www.ninjavan.co/th-th/tracking', trackable: true },
      'thailand-post': { name: 'Thai Post', url: 'https://track.thailandpost.co.th/', trackable: true },
    }

    th_carriers.each do |code, attr|
      Policy::ShippingCarrier.create(code: code, country: Country.th, **attr)
    end
  end

  def down
    Policy::ShippingCarrier.where(country: Country.th).delete_all
  end
end
