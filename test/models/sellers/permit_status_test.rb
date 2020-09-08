# == Schema Information
#
# Table name: sellers_permit_statuses
#
#  id         :bigint           not null, primary key
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class Sellers::PermitStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
