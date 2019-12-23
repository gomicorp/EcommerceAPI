class AdjustmentProductItem < ApplicationRecord
  belongs_to :adjustment
  belongs_to :product_item
end
