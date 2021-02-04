# == Schema Information
#
# Table name: sellers_store_infos
#
#  id             :bigint           not null, primary key
#  comment        :text(65535)
#  name           :text(65535)      not null
#  url            :text(65535)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  seller_info_id :bigint
#
# Indexes
#
#  index_sellers_store_infos_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
require 'test_helper'

class Sellers::StoreInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
