# == Schema Information
#
# Table name: sellers_item_sold_papers
#
#  id              :bigint           not null, primary key
#  adjusted_profit :integer          default(0)
#  ordered         :boolean          default(FALSE)
#  paid            :boolean          default(FALSE)
#  paid_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  item_id         :bigint           not null
#  seller_info_id  :bigint           not null
#
# Indexes
#
#  index_sellers_item_sold_papers_on_item_id         (item_id)
#  index_sellers_item_sold_papers_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => cart_items.id)
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class ItemSoldPaper < ApplicationRecord
    belongs_to :item, class_name: 'CartItem'
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    scope :paid, -> { where(paid: true) }
    scope :not_paid, -> { where(paid: false) }
    scope :cancelled, -> { where(item: CartItem.cancelled) }
    scope :not_cancelled, -> { where.not(item: CartItem.cancelled)}

    #======== ransack custom methd ========
    def self.paid_at_monthly_range(date)
      date_time = date.to_time
      range = date_time.beginning_of_month..date_time.end_of_month
      where(paid_at: range)
    end

    def self.ransackable_scopes(auth = nil)
      %i[paid_at_monthly_range]
    end
    #======================================

    def paid?
      paid
    end

    def cancelled?
      item.cancelled?
    end

    def pay!
      update(paid: true, paid_at: DateTime.now)
    end

    def order!
      update(ordered: true)
    end

    def ordered?
      ordered
    end

    # paid 상태에 따라 증/감 해야하는지를 판단하여 토글식으로 동작
    def apply_seller_profit
      if paid?
        seller_info.update(
          cumulative_amount: seller_info.cumulative_amount - item.result_price,
          cumulative_profit: seller_info.cumulative_profit - adjusted_profit,
          present_profit: seller_info.present_profit - adjusted_profit,
          withdrawable_profit: seller_info.withdrawable_profit - adjusted_profit # 현재 별도의 출금방어 정책이 없어 present_profit와 동일함.
        )
      else
        seller_info.update(
          cumulative_amount: seller_info.cumulative_amount + item.result_price,
          cumulative_profit: seller_info.cumulative_profit + adjusted_profit,
          present_profit: seller_info.present_profit + adjusted_profit,
          withdrawable_profit: seller_info.withdrawable_profit + adjusted_profit # 현재 별도의 출금방어 정책이 없어 present_profit와 동일함.
        )
      end
    end

    def reset_profit
      return if paid?

      update(adjusted_profit: item.result_price * seller_info.commission_rate)
    end
  end
end
