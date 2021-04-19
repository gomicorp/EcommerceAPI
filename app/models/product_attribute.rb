# == Schema Information
#
# Table name: product_attributes
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_product_attributes_on_deleted_at  (deleted_at)
#
class ProductAttribute < ApplicationRecord
  acts_as_paranoid
  has_many :options, class_name: 'ProductAttributeOption', dependent: :destroy

  has_many :product_attribute_product_item_groups
  has_many :item_groups, through: :product_attribute_product_item_groups
  has_one :zohomap, as: :zohoable
end
