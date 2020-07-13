module Sellers
  class SelectedProduct < ApplicationRecord
    validates_uniqueness_of :product_id, scope: :store_info
    belongs_to :store_info, class_name: 'Sellers::StoreInfo'
    belongs_to :product

  end
end
