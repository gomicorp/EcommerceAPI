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
