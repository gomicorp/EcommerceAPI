class CartItemBarcode < ApplicationRecord
  belongs_to :cart_items, class_name: 'CartItem'
  belongs_to :item_barcodes, class_name: 'ProductItemBarcode'
end
