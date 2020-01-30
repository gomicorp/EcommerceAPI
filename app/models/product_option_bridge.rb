class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
  validates_presence_of :connectable_id
  validates_uniqueness_of :connectable_id
end
