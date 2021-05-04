# == Schema Information
#
# Table name: order_confirmations
#
#  id            :bigint           not null, primary key
#  contact_count :integer          default(0)
#  memo          :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_info_id :bigint           not null
#
# Indexes
#
#  index_order_confirmations_on_order_info_id  (order_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_info_id => order_infos.id)
#
class OrderConfirmation < ApplicationRecord
  STATUS = %w[
    pending
    in_touch
    confirmed
    canceled
  ].freeze
  IN_CONFIRM_STATUS = %w[
  pending
  in_touch
  ].freeze

  enum status: STATUS.to_echo
  act_as_status_loggable status_list: STATUS.to_echo

  belongs_to :order_info
end
