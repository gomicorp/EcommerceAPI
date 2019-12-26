class ProductItemContainer < ApplicationRecord
  has_many :product_item_rows
  has_many :product_items, through: :product_item_rows
  has_one :zohomap, as: :zohoable
end
