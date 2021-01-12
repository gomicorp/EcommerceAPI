# == Schema Information
#
# Table name: external_channel_order_infos
#
#  id                        :bigint           not null, primary key
#  cancelled_status          :string(255)
#  channel                   :string(255)
#  customer_name             :string(255)
#  order_number              :string(255)
#  order_status              :string(255)
#  ordered_at                :datetime
#  paid_at                   :datetime
#  pay_method                :string(255)
#  row_data                  :text(65535)
#  ship_fee                  :integer
#  shipping_status           :string(255)
#  total_price               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  country_id                :bigint
#  external_channel_order_id :string(255)
#
# Indexes
#
#  index_external_channel_order_infos_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
require 'test_helper'

module ExternalChannel
  class OrderInfoTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
