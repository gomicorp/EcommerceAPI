class ProductItem < ApplicationRecord
  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :item_group_id
  has_many :product_item_product_options
  has_many :options, class_name: 'ProductOption', through: :product_item_product_options
  has_one :zohomap, as: :zohoable
end
