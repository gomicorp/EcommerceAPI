# == Schema Information
#
# Table name: sellers_settlement_statements
#
#  id                      :bigint           not null, primary key
#  accepted_at             :datetime
#  captured_account_number :text(65535)      not null
#  captured_bank           :text(65535)      not null
#  captured_country        :string(255)      default("global"), not null
#  captured_owner_name     :text(65535)      not null
#  requested_at            :datetime
#  settlement_amount       :integer
#  status                  :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  seller_info_id          :bigint           not null
#
# Indexes
#
#  index_sellers_settlement_statements_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
require 'test_helper'

class Sellers::SettlementStatementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
