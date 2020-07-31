# == Schema Information
#
# Table name: adjustment_product_items
#
#  id              :bigint           not null, primary key
#  is_positive     :boolean
#  quantity        :integer
#  adjustment_id   :bigint
#  product_item_id :bigint
#
# Indexes
#
#  index_adjustment_product_items_on_adjustment_id    (adjustment_id)
#  index_adjustment_product_items_on_product_item_id  (product_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (adjustment_id => adjustments.id)
#  fk_rails_...  (product_item_id => product_items.id)
#
class AdjustmentProductItem < ApplicationRecord
  belongs_to :adjustment
  belongs_to :product_item
end
