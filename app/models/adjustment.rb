# 이렇게 하면 Zohomap이 만들어진다.
# Zohomap.create(:zohoable => Adjustment.all[0], :zoho_id => "adadfdsf")

# 이렇게 하면 Adjustment가 반환된다.
# Zohomap.all[0].zohoable
class Adjustment < NationRecord
  REASONS = ['Input from Korea', 'Order', 'Return back'].freeze

  has_many :adjustment_product_items
  has_many :product_items, through: :adjustment_product_items
  has_one :zohomap, as: :zohoable

  validates_presence_of :reason
  validates :amount, numericality: { other_than: 0 }
end
