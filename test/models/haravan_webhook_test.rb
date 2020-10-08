# == Schema Information
#
# Table name: haravan_webhooks
#
#  id         :bigint           not null, primary key
#  event_name :string(255)
#  is_applied :boolean
#  table_name :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  haravan_id :string(255)
#
require 'test_helper'

class HaravanWebhookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
