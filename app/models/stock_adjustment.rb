# == Schema Information
#
# Table name: stock_adjustments
#
#  id               :bigint           not null, primary key
#  amount           :integer          default(0), not null
#  fulfilled        :boolean          default(FALSE)
#  memo             :text(65535)
#  reason           :string(255)
#  result_quantity  :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country_id       :bigint
#  order_info_id    :bigint
#  product_item_id  :bigint           default(0), not null
#  stock_invoice_id :bigint
#
# Indexes
#
#  fk_rails_473ea57bf2                          (product_item_id)
#  index_stock_adjustments_on_country_id        (country_id)
#  index_stock_adjustments_on_order_info_id     (order_info_id)
#  index_stock_adjustments_on_stock_invoice_id  (stock_invoice_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (product_item_id => product_items.id)
#  fk_rails_...  (stock_invoice_id => stock_invoices.id)
#

# 이렇게 하면 Adjustment가 반환된다.
# Zohomap.all[0].zohoable
class StockAdjustment < NationRecord
  REASONS = ['Input from Korea', 'Order', 'Return back'].freeze

  belongs_to :order_info, optional: true
  belongs_to :stock_invoice, optional: true
  belongs_to :product_item

  validates_presence_of :reason
  validates :amount, numericality: { other_than: 0 }

  scope :fulfilled, -> { where(fulfilled: true) }

end
