# == Schema Information
#
# Table name: external_channel_order_infos
#
#  id                        :bigint           not null, primary key
#  cancelled_status          :string(255)
#  channel                   :string(255)
#  order_number              :string(255)
#  order_status              :string(255)
#  ordered_at                :datetime
#  paid_at                   :datetime
#  pay_method                :string(255)
#  ship_fee                  :integer
#  shipping_status           :string(255)
#  total_price               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  country_id                :bigint
#  external_channel_order_id :integer
#
# Indexes
#
#  index_external_channel_order_infos_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class ExternalChannelOrderInfo < NationRecord
  has_many :external_channel_order_info_brands, class_name: 'ExternalChannelOrderInfoBrand', dependent: :destroy
  has_many :brands, class_name: 'Brand', through: :external_channel_order_info_brands
  has_many :external_channel_cart_items, class_name: 'ExternalChannelCartItem'
  has_many :product_options, through: :external_channel_cart_items
  has_many :products, through: :product_options

  zombie :product_options
end
