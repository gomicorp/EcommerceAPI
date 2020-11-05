# == Schema Information
#
# Table name: sellers_seller_infos
#
#  id                  :bigint           not null, primary key
#  cumulative_amount   :integer          default(0)
#  cumulative_profit   :integer          default(0)
#  present_profit      :integer          default(0)
#  purpose             :text(65535)
#  sns_name            :string(255)
#  withdrawable_profit :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  grade_id            :bigint           not null
#  seller_id           :bigint           not null
#  sns_id              :string(255)
#
# Indexes
#
#  index_sellers_seller_infos_on_grade_id   (grade_id)
#  index_sellers_seller_infos_on_seller_id  (seller_id)
#
# Foreign Keys
#
#  fk_rails_...  (grade_id => sellers_grades.id)
#  fk_rails_...  (seller_id => users.id)
#
require 'test_helper'

class Sellers::SellerInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
