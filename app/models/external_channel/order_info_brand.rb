# == Schema Information
#
# Table name: external_channel_order_info_brands
#
#  id                             :bigint           not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  brand_id                       :bigint           not null
#  external_channel_order_info_id :bigint           not null
#
# Indexes
#
#  brand_index       (brand_id)
#  order_info_index  (external_channel_order_info_id)
#
module ExternalChannel
  class OrderInfoBrand < ApplicationRecord
    belongs_to :external_channel_order_info, class_name: 'ExternalChannel::OrderInfo', dependent: :destroy
    belongs_to :brand, dependent: :destroy

    validates_uniqueness_of :brand_id, scope: %i[external_channel_order_info_id]
  end
end
