class StockInvoice < NationRecord
  has_many :stock_adjustments
  has_many :product_items, through: :stock_adjustments

  TYPES = %w[
    addition
    reduction
    correction
  ].freeze.to_echo

  alias_attribute :type, :invoice_type
  enum type: TYPES

  scope :by_type, -> type { where(invoice_type: type) }

  def confirmed?
    !!confirmed_at
  end

end
