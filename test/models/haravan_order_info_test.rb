# == Schema Information
#
# Table name: haravan_order_infos
#
#  id               :bigint           not null, primary key
#  channel          :string(255)
#  order_status     :integer
#  ordered_at       :datetime
#  paid_at          :datetime
#  pay_method       :string(255)
#  ship_fee         :integer
#  total_price      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  haravan_order_id :integer
#
require 'test_helper'

class HaravanOrderInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
