# == Schema Information
#
# Table name: sellers_account_infos
#
#  id             :bigint           not null, primary key
#  account_number :text(65535)
#  bank           :text(65535)
#  country        :string(255)      default("global"), not null
#  owner_name     :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  seller_info_id :bigint
#
# Indexes
#
#  index_sellers_account_infos_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class AccountInfo < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
  end
end
