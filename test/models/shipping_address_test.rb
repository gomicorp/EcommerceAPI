# == Schema Information
#
# Table name: shipping_addresses
#
#  id           :bigint           not null, primary key
#  loc_state    :string(255)
#  loc_city     :string(255)
#  loc_district :string(255)
#  loc_detail   :text(65535)
#  postal_code  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class ShippingAddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
