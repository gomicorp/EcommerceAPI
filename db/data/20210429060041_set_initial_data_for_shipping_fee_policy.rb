class SetInitialDataForShippingFeePolicy < ActiveRecord::Migration[6.0]
  FEE_TABLE = {
    th: {
      normal: [
        {feature: '-', fee: 30}
      ],
      express: [
        {feature: '-', fee: 50, default: true},
        {feature: 'bulk', fee: 60}
      ],
      cod: [
        {feature: 'downtown', fee: 50},
        {feature: 'suburb', fee: 60}
      ],
      free: [
        {feature: '-', fee: 0}
      ]
    },
    vn: {
      normal: [
        {feature: 'downtown', fee: 20_000, default: true},
        {feature: 'suburb', fee: 30_000}
      ],
      cod: [
        {feature: 'downtown', fee: 20_000},
        {feature: 'suburb', fee: 30_000}
      ],
      '2h': [
        {feature: 'hochiminh', fee: 35_000},
        {feature: 'hanoi', fee: 40_000},
      ],
      free: [
        {feature: '-', fee: 0}
      ]
    },
    ko: {
      normal: [
        {feature: '-', fee: 3000, default: true}
      ],
      free: [
        {feature: '-', fee: 0}
      ]
    }
  }.freeze

  def up
    FEE_TABLE.each do |country, types|
      country_record = Country.send(country.to_sym)
      types.each do |type, policies|
        policies.each do |pol|
          is_default = !!pol[:default]

          Policy::ShippingFee.create(
            country: country_record,
            delivery_type: type.to_s,
            feature: pol[:feature],
            fee: pol[:fee],
            default: is_default,
            current: true
          )
        end
      end
    end
  end

  def down
    FEE_TABLE.each do |country, types|
      country_record = Country.send(country.to_sym)
      types.each do |type, policies|
        policies.each do |pol|

          Policy::ShippingFee.where(
            country: country_record,
            delivery_type: type.to_s,
            feature: pol[:feature],
          ).destroy_all
        end
      end
    end
  end
end
