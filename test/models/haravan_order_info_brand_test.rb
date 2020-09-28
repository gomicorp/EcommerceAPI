# == Schema Information
#
# Table name: haravan_order_info_brands
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  brand_id              :bigint           not null
#  haravan_order_info_id :bigint           not null
#
# Indexes
#
#  index_haravan_order_info_brands_on_brand_id               (brand_id)
#  index_haravan_order_info_brands_on_haravan_order_info_id  (haravan_order_info_id)
#
require 'test_helper'

class HaravanOrderInfoBrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
