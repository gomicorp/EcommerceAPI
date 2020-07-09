class Sellers
  class SellerInfo < ApplicationRecord
    belongs_to :seller
    has_one :store_info, class_name: 'Sellers::StoreInfo'
    has_one :account_info, class_name: 'Sellers::AccountInfo'

    has_many :permit_change_lists, class_name: 'Sellers::PermitChangeList'
    has_many :settlement_statements, class_name: 'Sellers::SettlementStatement'

    def permit_status
      permit_change_lists.last.permit_status
    end
  end
end

