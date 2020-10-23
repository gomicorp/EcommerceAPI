# == Schema Information
#
# Table name: external_channel_order_info_product_options
#
#  id                             :bigint           not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  external_channel_order_info_id :bigint           not null
#  product_option_id              :bigint           not null
#
# Indexes
#
#  order_info_index      (external_channel_order_info_id)
#  product_option_index  (product_option_id)
#
require 'test_helper'

class ExternalChannelOrderInfoProductOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
