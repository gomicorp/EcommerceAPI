# == Schema Information
#
# Table name: adjustments
#
#  id              :bigint           not null, primary key
#  amount          :integer          default(0), not null
#  memo            :text(65535)
#  reason          :string(255)
#  result_quantity :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  country_id      :bigint
#  order_info_id   :bigint
#
# Indexes
#
#  index_adjustments_on_country_id     (country_id)
#  index_adjustments_on_order_info_id  (order_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#

# 이렇게 하면 Adjustment가 반환된다.
# Zohomap.all[0].zohoable
class Adjustment < NationRecord
  REASONS = ['Input from Korea', 'Order', 'Return back'].freeze

  belongs_to :order_info
  has_many :adjustment_product_items
  has_many :product_items, through: :adjustment_product_items
  has_one :zohomap, as: :zohoable

  validates_presence_of :reason
  validates :amount, numericality: { other_than: 0 }
end
