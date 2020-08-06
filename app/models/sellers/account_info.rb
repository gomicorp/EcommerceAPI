# == Schema Information
#
# Table name: sellers_account_infos
#
#  id             :bigint           not null, primary key
#  account_number :text(65535)
#  owner_name     :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  bank_id        :bigint
#  seller_info_id :bigint
#
# Indexes
#
#  index_sellers_account_infos_on_bank_id         (bank_id)
#  index_sellers_account_infos_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (bank_id => banks.id)
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class AccountInfo < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    belongs_to :bank

    validates_uniqueness_of :seller_info_id
  end
end
