# == Schema Information
#
# Table name: sellers_seller_infos
#
#  id                  :bigint           not null, primary key
#  cumulative_amount   :integer          default(0)
#  cumulative_profit   :integer          default(0)
#  present_profit      :integer          default(0)
#  withdrawable_profit :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  grade_id            :bigint           not null
#  seller_id           :bigint           not null
#
# Indexes
#
#  index_sellers_seller_infos_on_grade_id   (grade_id)
#  index_sellers_seller_infos_on_seller_id  (seller_id)
#
# Foreign Keys
#
#  fk_rails_...  (grade_id => sellers_grades.id)
#  fk_rails_...  (seller_id => users.id)
#
module Sellers
  class SellerInfo < ApplicationRecord
    belongs_to :seller
    has_one :store_info, class_name: 'Sellers::StoreInfo', dependent: :destroy
    has_one :account_info, class_name: 'Sellers::AccountInfo', dependent: :destroy
    belongs_to :grade, class_name: 'Sellers::Grade'

    has_many :permit_change_lists, class_name: 'Sellers::PermitChangeList', dependent: :destroy
    has_one :permission, -> { order('created_at DESC') }, class_name: 'Sellers::PermitChangeList'
    has_one :permit_status, through: :permission, class_name: 'Sellers::PermitStatus'

    has_many :settlement_statements, class_name: 'Sellers::SettlementStatement', dependent: :destroy
    has_many :order_sold_papers, class_name: 'Sellers::OrderSoldPaper', dependent: :destroy

    has_many :order_infos, through: :order_sold_papers

    scope :permitted, -> { where(permission: PermitChangeList.where(permit_status: PermitStatus.permitted)) }
    scope :applied, -> { where(permission: PermitChangeList.where(permit_status: PermitStatus.applied)) }

    delegate :name, to: :seller
    delegate :email, to: :seller
    delegate :phone_number, to: :seller
    delegate :commission_rate, to: :grade

    def permitted?
      update_status_cache
      permit_status == PermitStatus.permitted
    end

    def play_permit!(reason = nil)
      permit_change_lists << PermitChangeList.new(
        permit_status: PermitStatus.permitted,
        reason: reason
      )
      update_status_cache
    end

    def play_stop!(reason)
      permit_change_lists << PermitChangeList.new(
        permit_status: PermitStatus.stopped,
        reason: reason
      )
      update_status_cache
    end

    def init_permit_status!
      permit_change_lists << PermitChangeList.new(
        permit_status: PermitStatus.applied
      )
      update_status_cache
    end

    def update_counter_cache(order_sold_paper = nil)
      if order_sold_paper.nil?
        update_columns(
          cumulative_amount: order_infos.map(&:payment).sum(&:total_price_sum),
          cumulative_profit: order_sold_papers.sum(&:adjusted_profit)
        )
      else
        order_info = order_sold_paper.order_info
        update_columns(
          cumulative_amount: cumulative_amount + order_info.payment.total_price_sum,
          cumulative_profit: cumulative_profit + order_sold_paper.adjusted_profit
        )
      end
    end

    private

    def update_status_cache
      update(permit_status: permission.permit_status)
    end
  end
end
