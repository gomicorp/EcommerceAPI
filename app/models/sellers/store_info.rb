# == Schema Information
#
# Table name: sellers_store_infos
#
#  id             :bigint           not null, primary key
#  comment        :text(65535)
#  name           :text(65535)      not null
#  url            :text(65535)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  seller_info_id :bigint
#
# Indexes
#
#  index_sellers_store_infos_on_seller_info_id  (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
module Sellers
  class StoreInfo < ApplicationRecord
    validates_uniqueness_of :url, case_sensitive: false

    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    has_many :selected_products, class_name: 'Sellers::SelectedProduct', dependent: :destroy
  end
end
