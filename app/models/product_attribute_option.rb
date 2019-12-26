class ProductAttributeOption < ApplicationRecord
  belongs_to :product_attribute
  has_one :zohomap, as: :zohoable
end
