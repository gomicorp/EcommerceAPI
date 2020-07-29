module Sellers
  class PermitChangeList < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    belongs_to :permit_status, class_name: 'Sellers::PermitStatus'
  end
end
