class Payment::Charge < NationRecord
  STATUS = %w[
    pending
    paid
    expired
    refunded
  ].freeze
  enum status: STATUS.to_echo

  belongs_to :payment

  def statement
    JSON.parse self[:statement] if self[:statement]
  end

end
