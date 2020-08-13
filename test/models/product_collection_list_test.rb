# == Schema Information
#
# Table name: product_collection_lists
#
#  item_id       :bigint           not null, primary key
#  collection_id :bigint           not null
#  unit_count    :bigint           default(0), not null
#
require 'test_helper'

class ProductCollectionListTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
