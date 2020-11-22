# == Schema Information
#
# Table name: external_channel_cart_items
#
#  id                             :bigint           not null, primary key
#  option_count                   :integer          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  country_id                     :bigint
#  external_channel_order_info_id :bigint
#  external_option_id             :string(255)      not null
#  product_option_id              :bigint
#
# Indexes
#
#  ec_cart_items_on_ec_order_info_id                       (external_channel_order_info_id)
#  index_external_channel_cart_items_on_country_id         (country_id)
#  index_external_channel_cart_items_on_product_option_id  (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (external_channel_order_info_id => external_channel_order_infos.id)
#
require 'test_helper'

class ExternalChannelCartItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
