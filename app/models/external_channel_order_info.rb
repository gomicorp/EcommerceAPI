# == Schema Information
#
# Table name: external_channel_order_infos
#
#  id                        :bigint           not null, primary key
#  cancelled_status          :string(255)
#  channel                   :string(255)
#  order_number              :string(255)
#  order_status              :integer
#  ordered_at                :datetime
#  paid_at                   :datetime
#  pay_method                :string(255)
#  ship_fee                  :integer
#  shipping_status           :string(255)      not null
#  total_price               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  external_channel_order_id :integer
#
class ExternalChannelOrderInfo < ApplicationRecord
  ORDER_STATUSES = %w[pending authorized partiallypaid paid partiallyrefunded refunded voided]
  enum order_status: ORDER_STATUSES

  has_many :external_channel_order_info_brands, class_name: 'ExternalChannelOrderInfoBrand', dependent: :destroy
  has_many :brands, class_name: 'Brand', through: :external_channel_order_info_brands
  has_many :external_channel_cart_items, class_name: 'ExternalChannelCartItem'
  has_many :product_options, through: :external_channel_cart_items
  has_many :products, through: :product_options

  zombie :product_options
end
