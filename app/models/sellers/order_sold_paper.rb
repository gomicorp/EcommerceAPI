module Sellers
  class OrderSoldPaper < ApplicationRecord
    belongs_to :order_info
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    def paid?
      paid
    end

    def pay!
      update(paid: true, paid_at: DateTime.now)
    end
  end
end
