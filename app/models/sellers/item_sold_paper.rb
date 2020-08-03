module Sellers
  class ItemSoldPaper < ApplicationRecord
    belongs_to :item, class_name: 'CartItem'
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    def paid?
      paid
    end

    def pay!
      update(paid: true, paid_at: DateTime.now)
    end
  end
end
