class CartItemBarcode < ApplicationRecord
  belongs_to :cart_item, class_name: 'CartItem'
  belongs_to :product_item_barcode, class_name: 'ProductItemBarcode'
end
