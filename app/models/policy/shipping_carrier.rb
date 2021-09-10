class Policy::ShippingCarrier < NationRecord
  belongs_to :country

  scope :trackable, -> { where(trackable: true) }

  def self.code_list
    pluck(:code)
  end

  def self.list
    pluck(:name)
  end
end
