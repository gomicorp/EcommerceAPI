class ProductAttributeProductItemGroup < ApplicationRecord
  acts_as_paranoid
  belongs_to :product_attribute, dependent: :destroy
  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :product_item_group_id
end
