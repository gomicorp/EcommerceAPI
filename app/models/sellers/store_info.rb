module Sellers
  class StoreInfo < ApplicationRecord
    validates_uniqueness_of :url, case_sensitive: false

    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    has_many :selected_products, class_name: 'Sellers::SelectedProduct', dependent: :destroy
  end
end
