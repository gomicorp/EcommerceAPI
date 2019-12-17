class ProductAttribute < ApplicationRecord
  has_many :product_attribute_options

  has_many :product_attribute_product_item_groups
  has_many :product_item_groups, through: :product_attribute_product_item_groups
end
