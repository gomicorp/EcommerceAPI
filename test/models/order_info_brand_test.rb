# == Schema Information
#
# Table name: order_info_brands
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  brand_id      :bigint           not null
#  order_info_id :bigint           not null
#
# Indexes
#
#  index_order_info_brands_on_brand_id       (brand_id)
#  index_order_info_brands_on_order_info_id  (order_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (order_info_id => order_infos.id)
#
require 'test_helper'

class OrderInfoBrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
