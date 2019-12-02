class ProductOptionGroup < ApplicationRecord
  belongs_to :product
  has_many :options, class_name: ProductOption.name
end
