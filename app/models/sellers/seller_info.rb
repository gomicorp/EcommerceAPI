# == Schema Information
#
# Table name: sellers_seller_infos
#
#  id                      :bigint           not null, primary key
#  cumulative_amount       :integer          default(0)
#  cumulative_profit       :integer          default(0)
#  present_profit          :integer          default(0)
#  purpose                 :text(65535)
#  seller_email            :string(255)
#  withdrawable_profit     :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  grade_id                :bigint           not null
#  seller_id               :bigint           not null
#  sns_id                  :string(255)
#  social_media_service_id :bigint
#
# Indexes
#
#  index_sellers_seller_infos_on_grade_id                 (grade_id)
#  index_sellers_seller_infos_on_seller_id                (seller_id)
#  index_sellers_seller_infos_on_social_media_service_id  (social_media_service_id)
#
# Foreign Keys
#
#  fk_rails_...  (grade_id => sellers_grades.id)
#  fk_rails_...  (seller_id => users.id)
#
module Sellers
  class SellerInfo < ApplicationRecord
    belongs_to :seller
    belongs_to :social_media_service, class_name: 'SocialMediaService'
    has_one :store_info, class_name: 'Sellers::StoreInfo', dependent: :destroy
    has_many :account_infos, class_name: 'Sellers::AccountInfo', dependent: :destroy
    has_many :seller_info_interest_tags, class_name: 'SellerInfoInterestTag', dependent: :destroy
    has_many :interest_tags, through: :seller_info_interest_tags
    belongs_to :grade, class_name: 'Sellers::Grade'

    has_many :permit_change_lists, class_name: 'Sellers::PermitChangeList', dependent: :destroy
    has_one :permission, -> { order('created_at DESC') }, class_name: 'Sellers::PermitChangeList'
    has_one :permit_status, through: :permission, class_name: 'Sellers::PermitStatus'

    has_many :settlement_statements, class_name: 'Sellers::SettlementStatement', dependent: :destroy
    has_many :item_sold_papers, class_name: 'Sellers::ItemSoldPaper', dependent: :destroy
    has_many :items, through: :item_sold_papers
    has_many :order_infos, -> { distinct }, class_name: 'OrderInfo', through: :items

    scope :permitted, -> { where(permission: Sellers::PermitChangeList.where(permit_status: Sellers::PermitStatus.permitted)) }
    scope :applied, -> { where(permission: Sellers::PermitChangeList.where(permit_status: Sellers::PermitStatus.applied)) }

    delegate :name, to: :seller
    delegate :email, to: :seller
    delegate :phone_number, to: :seller
    delegate :commission_rate, to: :grade

    validates_uniqueness_of :seller_id

    def permitted?
      update_status_cache
      permit_status == Sellers::PermitStatus.permitted
    end

    def play_permit!(reason = nil)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.permitted,
        reason: reason
      )
      update_status_cache
    end

    def play_stop!(reason)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.stopped,
        reason: reason
      )
      update_status_cache
    end

    def init_permit_status!
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.applied
      )
      update_status_cache
    end

    def update_seller_counts
      cumulative_profit = item_sold_papers.paid.sum(&:adjusted_profit)
      withdrew_profit = settlement_statements.accepted.sum(&:settlement_amount)
      update(
        cumulative_amount: items.captured.not_cancelled.sum(&:result_price),
        cumulative_profit: cumulative_profit,
        present_profit: cumulative_profit - withdrew_profit,
        withdrawable_profit: cumulative_profit - withdrew_profit # 현재 별도의 출금방어 정책이 없어 present_profit와 동일함.
      )
    end

    private

    def update_status_cache
      update(permit_status: permission.permit_status)
    end
  end
end
