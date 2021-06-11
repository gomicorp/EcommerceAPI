class Payment::Charge < NationRecord
  belongs_to :payment

  def supplement
    JSON.parse self[:supplement] if self[:supplement]
  end

end
