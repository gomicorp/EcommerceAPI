# == Schema Information
#
# Table name: haravan_order_info_options
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  haravan_order_info_id :bigint           not null
#  product_option_id     :bigint           not null
#
# Indexes
#
#  index_haravan_order_info_options_on_haravan_order_info_id  (haravan_order_info_id)
#  index_haravan_order_info_options_on_product_option_id      (product_option_id)
#
require 'test_helper'

class HaravanOrderInfoOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
