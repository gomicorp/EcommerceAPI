class ProductItemBarcode < ApplicationRecord
  belongs_to :product_item

  has_many :options, through: :product_item
end
