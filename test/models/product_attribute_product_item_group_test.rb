# == Schema Information
#
# Table name: product_attribute_product_item_groups
#
#  id                    :bigint           not null, primary key
#  deleted_at            :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  product_attribute_id  :bigint           not null
#  product_item_group_id :bigint           not null
#
# Indexes
#
#  index_p_attribute__p_item_group_on_p_attribute_id          (product_attribute_id)
#  index_p_item_group__p_attribute_on_p_item_group_id         (product_item_group_id)
#  index_product_attribute_product_item_groups_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_...  (product_attribute_id => product_attributes.id)
#  fk_rails_...  (product_item_group_id => product_item_groups.id)
#
require 'test_helper'

class ProductAttributeProductItemGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
