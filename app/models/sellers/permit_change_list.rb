# == Schema Information
#
# Table name: sellers_permit_change_lists
#
#  id               :bigint           not null, primary key
#  reason           :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  permit_status_id :bigint           not null
#  seller_info_id   :bigint           not null
#
# Indexes
#
#  index_sellers_permit_change_lists_on_permit_status_id  (permit_status_id)
#  index_sellers_permit_change_lists_on_seller_info_id    (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (permit_status_id => sellers_permit_statuses.id)
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class PermitChangeList < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    belongs_to :permit_status, class_name: 'Sellers::PermitStatus'
  end
end
