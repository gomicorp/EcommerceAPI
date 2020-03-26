class ProductOptionGroup < ApplicationRecord
  belongs_to :product
  has_many :options, class_name: 'ProductOption'
end
