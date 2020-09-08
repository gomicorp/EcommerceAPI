# == Schema Information
#
# Table name: product_option_groups
#
#  id          :bigint           not null, primary key
#  is_required :boolean          default(TRUE), not null
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint
#
# Indexes
#
#  index_product_option_groups_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class ProductOptionGroup < ApplicationRecord
  belongs_to :product
  has_many :options, class_name: 'ProductOption'
end
