module Sellers
  class SettlementStatement < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    validates_inclusion_of :status, in: %w(requested accepted rejected)

    def confirm!
      update(status: 'accepted')
    end
  end
end
