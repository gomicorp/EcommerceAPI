class ProductOptionBrand < ApplicationRecord
  belongs_to :product_option, class_name: 'ProductOption'
  belongs_to :brand, class_name: 'Brand'

  validates_uniqueness_of :product_option_id, scope: :brand_id
end
