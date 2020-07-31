# == Schema Information
#
# Table name: cart_item_barcodes
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cart_item_id            :bigint           not null
#  product_item_barcode_id :bigint           not null
#
# Indexes
#
#  index_cart_item_barcodes_on_cart_item_id             (cart_item_id)
#  index_cart_item_barcodes_on_product_item_barcode_id  (product_item_barcode_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_item_id => cart_items.id)
#  fk_rails_...  (product_item_barcode_id => product_item_barcodes.id)
#
class CartItemBarcode < ApplicationRecord
  belongs_to :cart_item, class_name: 'CartItem'
  belongs_to :product_item_barcode, class_name: 'ProductItemBarcode'
end
