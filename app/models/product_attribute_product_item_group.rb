class ProductAttributeProductItemGroup < ApplicationRecord
  belongs_to :product_attribute
  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :product_item_group_id
end
