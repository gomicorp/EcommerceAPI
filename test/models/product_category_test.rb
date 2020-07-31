# == Schema Information
#
# Table name: product_categories
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  product_id  :bigint
#
# Indexes
#
#  index_product_categories_on_category_id                 (category_id)
#  index_product_categories_on_product_id                  (product_id)
#  index_product_categories_on_product_id_and_category_id  (product_id,category_id) UNIQUE
#
require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
