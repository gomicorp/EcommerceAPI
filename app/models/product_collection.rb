class ProductCollection < ApplicationRecord
  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements
  has_one :zohomap, as: :zohoable
  has_one :product_option_bridge, as: :connectable
end
