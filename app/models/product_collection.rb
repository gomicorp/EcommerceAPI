class ProductCollection < ApplicationRecord
  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements
  has_one :zohomap, as: :zohoable
  has_many :product_option_bridges, as: :connectable
end
