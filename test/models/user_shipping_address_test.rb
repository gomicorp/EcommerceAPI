# == Schema Information
#
# Table name: user_shipping_addresses
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  shipping_address_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_user_shipping_addresses_on_shipping_address_id              (shipping_address_id)
#  index_user_shipping_addresses_on_user_id                          (user_id)
#  index_user_shipping_addresses_on_user_id_and_shipping_address_id  (user_id,shipping_address_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (shipping_address_id => shipping_addresses.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class UserShippingAddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
