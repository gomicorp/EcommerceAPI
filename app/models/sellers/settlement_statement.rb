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

    validates_inclusion_of :status, in: STATUSES

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

      capture_account
      withdraw_request
    end

    private

    def withdraw_request
      seller_info.update!(withdrawable_profit: seller_info.withdrawable_profit - settlement_amount)
    end

    def capture_account(account_info = nil)
      account = account_info || seller_info.account_infos.first
      ap account
      assign_attributes(
        captured_country: account.bank.country.name,
        captured_bank: account.bank.name,
        captured_owner_name: account.owner_name,
        captured_account_number: account.account_number
      )
    end

  end
end
