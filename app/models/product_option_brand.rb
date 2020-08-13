# == Schema Information
#
# Table name: product_option_brands
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  brand_id          :bigint           not null
#  product_option_id :bigint           not null
#
# Indexes
#
#  index_product_option_brands_on_brand_id           (brand_id)
#  index_product_option_brands_on_product_option_id  (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (product_option_id => product_options.id)
#
class ProductOptionBrand < ApplicationRecord
  belongs_to :product_option, class_name: 'ProductOption'
  belongs_to :brand, class_name: 'Brand'

  validates_uniqueness_of :product_option_id, scope: :brand_id
end
