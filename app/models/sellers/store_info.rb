module Sellers
  class StoreInfo < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    has_many :selected_products, class_name: 'Sellers::SelectedProduct'
  end
end
