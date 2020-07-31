# == Schema Information
#
# Table name: sellers_grades
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  commission_rate :decimal(10, 2)   default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class Sellers::GradeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
