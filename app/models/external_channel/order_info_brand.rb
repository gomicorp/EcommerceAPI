module ExternalChannel
  class OrderInfoBrand < ApplicationRecord
    belongs_to :order_info, class_name: 'ExternalChannel::OrderInfo'
    belongs_to :brand

    validates_uniqueness_of :brand_id, scope: %i[order_info_id]
  end
end
