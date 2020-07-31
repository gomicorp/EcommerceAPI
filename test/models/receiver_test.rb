# == Schema Information
#
# Table name: receivers
#
#  id         :bigint           not null, primary key
#  email      :string(255)
#  name       :string(255)
#  tel        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_receivers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class ReceiverTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
