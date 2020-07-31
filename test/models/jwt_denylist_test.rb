# == Schema Information
#
# Table name: jwt_denylist
#
#  id  :bigint           not null, primary key
#  exp :datetime         not null
#  jti :string(255)      not null
#
# Indexes
#
#  index_jwt_denylist_on_jti  (jti)
#
require 'test_helper'

class JwtDenylistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
