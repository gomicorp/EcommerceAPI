# == Schema Information
#
# Table name: haravan_order_infos
#
#  id               :bigint           not null, primary key
#  cancelled_status :string(255)
#  channel          :string(255)
#  order_number     :string(255)
#  order_status     :integer
#  ordered_at       :datetime
#  paid_at          :datetime
#  pay_method       :string(255)
#  ship_fee         :integer
#  total_price      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  haravan_order_id :integer
#
class HaravanOrderInfo < ApplicationRecord
  ORDER_STATUSES = %w[pending authorized partiallypaid paid partiallyrefunded refunded voided]
  enum order_status: ORDER_STATUSES

  has_many :haravan_order_info_brands, class_name: 'HaravanOrderInfoBrand', dependent: :destroy
  has_many :brands, class_name: 'Brand', through: :haravan_order_info_brands
  has_many :haravan_order_info_options, class_name: 'HaravanOrderInfoOption', dependent: :destroy
  has_many :product_options, class_name: 'ProductOption', through: :haravan_order_info_options
  has_many :product_pages, through: :product_options

  zombie :product_options
end
