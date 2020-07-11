module Sellers
  class SelectedProduct < ApplicationRecord
    belongs_to :store_info, class_name: 'Sellers::StoreInfo'
    belongs_to :product

  end
end
