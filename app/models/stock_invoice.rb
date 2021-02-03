# == Schema Information
#
# Table name: stock_invoices
#
#  id            :bigint           not null, primary key
#  comment       :text(65535)
#  confirmed_at  :datetime
#  destination   :string(255)
#  from          :string(255)
#  invoice_type  :string(255)
#  requested_at  :datetime
#  serial_number :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  country_id    :bigint
#
# Indexes
#
#  index_stock_invoices_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
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
