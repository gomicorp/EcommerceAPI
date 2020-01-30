class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
end
