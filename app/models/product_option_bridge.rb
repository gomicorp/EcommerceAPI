class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
  belongs_to :product_option
end
