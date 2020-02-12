class Category < ApplicationRecord
  belongs_to :category

  has_many :product_categories, class_name: 'ProductCategory'
  has_many :products, through: :product_categories

  extend_has_one_attached :image

  validates_presence_of :name, :depth
end
