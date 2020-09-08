# == Schema Information
#
# Table name: product_permits
#
#  id           :bigint           not null, primary key
#  permitted_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  product_id   :bigint
#
# Indexes
#
#  index_product_permits_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class ProductPermit < ApplicationRecord
  belongs_to :product
end
