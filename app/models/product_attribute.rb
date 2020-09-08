# == Schema Information
#
# Table name: product_attributes
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProductAttribute < ApplicationRecord
  has_many :options, class_name: 'ProductAttributeOption'

  has_many :product_attribute_product_item_groups
  has_many :item_groups, through: :product_attribute_product_item_groups
  has_one :zohomap, as: :zohoable
end
