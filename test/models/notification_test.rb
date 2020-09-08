# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  domain     :string(255)
#  period     :datetime
#  published  :boolean
#  title      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint           not null
#
# Indexes
#
#  index_notifications_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
