class Payment::Charge < NationRecord
  STATUS = %w[
    pending
    paid
    expired
    refunded
  ].freeze
  enum status: STATUS.to_echo
  act_as_status_loggable status_list: STATUS.t

  belongs_to :payment

  def supplement
    JSON.parse self[:supplement] if self[:supplement]
  end

end
