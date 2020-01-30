class ProductItemBarcode < ApplicationRecord
  belongs_to :product_item

  has_many :options, class_name: 'ProductOption', through: :product_item
end
