# == Schema Information
#
# Table name: product_attribute_options
#
#  id                   :bigint           not null, primary key
#  deleted_at           :datetime
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  product_attribute_id :bigint           not null
#
# Indexes
#
#  index_product_attribute_options_on_deleted_at            (deleted_at)
#  index_product_attribute_options_on_product_attribute_id  (product_attribute_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_attribute_id => product_attributes.id)
#
class ProductAttributeOption < ApplicationRecord
  belongs_to :product_attribute
  has_one :zohomap, as: :zohoable
end
