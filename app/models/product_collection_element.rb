class ProductCollectionElement < ApplicationRecord
  belongs_to :product_item
  belongs_to :product_collection
end
