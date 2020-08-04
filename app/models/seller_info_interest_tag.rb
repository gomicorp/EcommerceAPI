# == Schema Information
#
# Table name: seller_info_interest_tags
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  interest_tag_id :bigint           not null
#  seller_info_id  :bigint           not null
#
# Indexes
#
#  index_seller_info_interest_tags_on_interest_tag_id  (interest_tag_id)
#  index_seller_info_interest_tags_on_seller_info_id   (seller_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (interest_tag_id => interest_tags.id)
#  fk_rails_...  (seller_info_id => sellers_seller_infos.id)
#
class SellerInfoInterestTag < ApplicationRecord
  belongs_to :seller_info, :class_name => 'Sellers::SellerInfo'
  belongs_to :interest_tag

  validates_presence_of :seller_info, :interest_tag
  validates_uniqueness_of :seller_info_id, scope: :interest_tag_id
end
