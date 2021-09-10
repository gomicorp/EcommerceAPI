class ProductAttributeOption < ApplicationRecord
  acts_as_paranoid
  belongs_to :product_attribute
  has_one :zohomap, as: :zohoable
end
