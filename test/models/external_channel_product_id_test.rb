# == Schema Information
#
# Table name: external_channel_product_ids
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  channel_id  :bigint           not null
#  external_id :string(255)      not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_external_channel_product_ids_on_channel_id  (channel_id)
#  index_external_channel_product_ids_on_product_id  (product_id)
#
require 'test_helper'

class ExternalChannelProductIdTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
