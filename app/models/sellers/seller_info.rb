module Sellers
  class SellerInfo < ApplicationRecord
    belongs_to :seller
    has_one :store_info, class_name: 'Sellers::StoreInfo'
    has_one :account_info, class_name: 'Sellers::AccountInfo'

    has_many :permit_change_lists, class_name: 'Sellers::PermitChangeList'
    has_many :settlement_statements, class_name: 'Sellers::SettlementStatement'
    has_many :order_sold_papers, class_name: 'Sellers::OrderSoldPaper'

    has_many :order_infos, through: :order_sold_papers

    def permit_status
      init_permit_status! if permit_change_lists.empty?
      permit_change_lists.last.permit_status
    end

    def play_permit!(reason)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.permitted,
        reason: reason
      )
    end

    def play_stop!(reason)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.stopped,
        reason: reason
      )
    end

    def init_permit_status!
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.applied
      )
    end

    def update_counter_cache(order_sold_paper = nil)
      if order_sold_paper.nil?
        update_columns(
          cumulative_amount: order_infos.map(&:payment).sum(&:total_price_sum),
          cumulative_profit: order_infos.map(&:order_sold_paper).sum(&:adjusted_profit)
        )
      else
        order_info = order_sold_paper.order_info
        update_columns(
          cumulative_amount: cumulative_amount + order_info.payment.total_price_sum,
          cumulative_profit: cumulative_profit + order_sold_paper.adjusted_profit
        )
      end
    end
  end
end
