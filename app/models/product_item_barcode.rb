class ProductItemBarcode < ApplicationRecord
  belongs_to :product_option_bridge
  has_many :options, class_name: 'ProductOption', through: :product_option_bridge
end
