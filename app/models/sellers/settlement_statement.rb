# == Schema Information
#
# Table name: sellers_settlement_statements
#
#  id                      :bigint           not null, primary key
#  accepted_at             :datetime
#  captured_account_number :text(65535)      not null
#  captured_bank           :text(65535)      not null
#  captured_country        :string(255)      default("global"), not null
#  captured_owner_name     :text(65535)      not null
#  requested_at            :datetime
#  settlement_amount       :integer
#  status                  :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  seller_info_id          :bigint           not null
#
# Indexes
#
#  index_sellers_settlement_statements_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class SettlementStatement < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    STATUSES = %w(requested accepted rejected)

    scope :requested, -> { where(status: 'requested') }
    scope :accepted, -> { where(status: 'accepted') }
    scope :rejected, -> { where(status: 'rejected') }

    validates_inclusion_of :status, in: STATUSES

    # ============================================================================
    # = ransack 커스텀 쿼리입니다.

    def self.created_at_monthly_range(date)
      range = date.to_time.beginning_of_month..date.to_time.end_of_month
      where(created_at: range)
    end

    def self.ransackable_scopes(auth = nil)
      %i[created_at_monthly_range]
    end

    # ============================================================================
    # = 레코드의 settlement amount 합계를 구하는 메소드입니다.

    def self.amount_sum(record)
      record.sum(&:settlement_amount)
    end

    # ============================================================================

    def confirm!
      return false if status != 'requested'

      seller_info.update(present_profit: seller_info.present_profit - settlement_amount)
      update(status: 'accepted', accepted_at: DateTime.now)
    end

    def reject!
      return false if status != 'requested'

      seller_info.update(withdrawable_profit: seller_info.withdrawable_profit + settlement_amount)
      update(status: 'rejected')
    end

    def status_changed_at
      case status
      when 'requested'
        requested_at || created_at
      when 'accepted'
        accepted_at
      else
        updated_at
      end
    end

    def stamped?
      status != 'requested'
    end

    def self.statuses
      STATUSES
    end

    def write_initial_state
      return false if status.nil?

      capture_account unless account_uncaptured?
      withdraw_request
    end

    def valid_before_create
      valid_amount? && valid_account_info?
    end

    def account_uncaptured?
      return true if captured_country.nil?
      return true if captured_bank.nil?
      return true if captured_owner_name.nil?
      return true if captured_account_number.nil?
    end

    def withdraw_request
      seller_info.update!(withdrawable_profit: seller_info.withdrawable_profit - settlement_amount)
    end

    def capture_account(account_info = nil)
      account = account_info || seller_info.account_infos.first
      assign_attributes(
        captured_country: account.bank.country.name,
        captured_bank: account.bank.name,
        captured_owner_name: account.owner_name,
        captured_account_number: account.account_number
      )
    end

    private

    def valid_amount?
      settlement_amount <= seller_info.withdrawable_profit
    end

    def valid_account_info?
      !Sellers::AccountInfo.find_by(account_number: captured_account_number, seller_info: seller_info).nil?
    end
  end
end
