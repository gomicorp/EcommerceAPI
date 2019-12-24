class ProductItemRow < ApplicationRecord
  belongs_to :product_item
  belongs_to :product_item_container
end
