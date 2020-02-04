class ProductCollectionList < ApplicationRecord
  belongs_to :collection, class_name: 'ProductCollection'
  belongs_to :item, class_name: 'ProductItem'
end
