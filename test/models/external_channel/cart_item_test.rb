# == Schema Information
#
# Table name: external_channel_cart_items
#
<<<<<<< HEAD
#  id                             :bigint           not null, primary key
#  option_count                   :integer          not null
#  unit_price                     :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  country_id                     :bigint
#  external_channel_order_info_id :bigint
#  product_option_id              :bigint
=======
#  id                :bigint           not null, primary key
#  option_count      :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_id        :bigint
#  order_info_id     :bigint
#  product_option_id :bigint
>>>>>>> 6d7fdf779e0f24ba41f11aa7171ccfe5df10843c
#
# Indexes
#
#  ec_cart_items_on_ec_order_info_id                       (order_info_id)
#  index_external_channel_cart_items_on_country_id         (country_id)
#  index_external_channel_cart_items_on_product_option_id  (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (order_info_id => external_channel_order_infos.id)
#
require 'test_helper'

module ExternalChannel
  class CartItemTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
