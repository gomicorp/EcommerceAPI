class ProductAttribute < ApplicationRecord
  acts_as_paranoid
  has_many :options, class_name: 'ProductAttributeOption', dependent: :destroy

  has_many :product_attribute_product_item_groups
  has_many :item_groups, through: :product_attribute_product_item_groups
  has_one :zohomap, as: :zohoable
end
