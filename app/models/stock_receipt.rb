# == Schema Information
#
# Table name: stock_receipts
#
#  id               :bigint           not null, primary key
#  comment          :text(65535)
#  confirmed_at     :datetime
#  from             :string(255)
#  requested_at     :datetime
#  serial_number    :string(255)
#  type             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country_id       :bigint
#  stock_receipt_id :bigint
#
# Indexes
#
#  index_stock_receipts_on_country_id        (country_id)
#  index_stock_receipts_on_stock_receipt_id  (stock_receipt_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (stock_receipt_id => stock_receipts.id)
#
class StockReceipt < NationRecord
  has_many :stock_adjustments
  has_many :stock_adjustment_product_items, through: :stock_adjustments
  has_many :product_items, through: :stock_adjustment_product_items

  TYPES = %w[
    addition
    reduction
    correction
  ].freeze.to_echo

  enum type: TYPES

end
