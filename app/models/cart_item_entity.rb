class CartItemEntity < ApplicationRecord
  belongs_to :cart_item, class_name: 'CartItem'
  belongs_to :product_item_entity, class_name: 'ProductItemEntity'
end
