module Sellers
  class PermitChangeList < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    has_one :permit_status, class_name: 'Sellers::PermitStatus'
  end
end
