class ProductCollection < ApplicationRecord
  has_many :product_collection_elements
  has_many :product_items, through: :product_collection_elements
  has_one :zohomap, as: :zohoable
end
