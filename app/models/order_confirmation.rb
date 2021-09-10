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
