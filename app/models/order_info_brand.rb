class OrderInfoBrand < ApplicationRecord
  belongs_to :order_info, class_name: 'OrderInfo'
  belongs_to :brand, class_name: 'Brand'

  validates_uniqueness_of :order_info_id, scope: :brand_id
end
