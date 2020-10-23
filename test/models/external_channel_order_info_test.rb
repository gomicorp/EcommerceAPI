# == Schema Information
#
# Table name: external_channel_order_infos
#
#  id                        :bigint           not null, primary key
#  cancelled_status          :string(255)
#  channel                   :string(255)
#  order_number              :string(255)
#  order_status              :integer
#  ordered_at                :datetime
#  paid_at                   :datetime
#  pay_method                :string(255)
#  ship_fee                  :integer
#  total_price               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  external_channel_order_id :integer
#
require 'test_helper'

class ExternalChannelOrderInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
