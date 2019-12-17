class ProductAttributeProductItemGroup < ApplicationRecord
  belongs_to :product_attribute
  belongs_to :product_item_group
end
