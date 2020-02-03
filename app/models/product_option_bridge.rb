class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
  has_many :product_options
end
