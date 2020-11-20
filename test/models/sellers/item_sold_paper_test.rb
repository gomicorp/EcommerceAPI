# == Schema Information
#
# Table name: sellers_item_sold_papers
#
#  id              :bigint           not null, primary key
#  adjusted_profit :integer          default(0)
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
require 'test_helper'

class Sellers::ItemSoldPaperTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
