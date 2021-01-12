# == Schema Information
#
# Table name: stock_adjustment_product_items
#
#  id                  :bigint           not null, primary key
#  is_positive         :boolean
#  quantity            :integer
#  product_item_id     :bigint
#  stock_adjustment_id :bigint
#
# Indexes
#
#  index_stock_adjustment_product_items_on_product_item_id      (product_item_id)
#  index_stock_adjustment_product_items_on_stock_adjustment_id  (stock_adjustment_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_item_id => product_items.id)
#  fk_rails_...  (stock_adjustment_id => stock_adjustments.id)
#
class StockAdjustmentProductItem < ApplicationRecord
  belongs_to :stock_adjustment
  belongs_to :product_item
end
