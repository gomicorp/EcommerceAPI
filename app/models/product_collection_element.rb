class ProductCollectionElement < ApplicationRecord
  belongs_to :product_item
  belongs_to :collection, class_name: 'ProductCollection'
end
