class Category < ApplicationRecord
  belongs_to :category
  has_many :product
  extend_has_one_attached :image
  has_many :product_categories, class_name: ProductCategory.name
  has_many :product, through: :product_categories

end
