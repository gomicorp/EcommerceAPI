# == Schema Information
#
# Table name: product_attributes
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_product_attributes_on_deleted_at  (deleted_at)
#
require 'test_helper'

class ProductAttributeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
