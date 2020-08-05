# == Schema Information
#
# Table name: sellers_item_sold_papers
#
#  id              :bigint           not null, primary key
#  adjusted_profit :integer          default(0)
#  ordered         :boolean          default(FALSE)
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
module Sellers
  class ItemSoldPaper < ApplicationRecord
    belongs_to :item, class_name: 'CartItem'
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    def paid?
      paid
    end

    def pay!
      update(paid: true, paid_at: DateTime.now)
    end

    def order!
      update(ordered: true)
    end

    def ordered?
      ordered
    end

    def reset_profit
      return if paid?

      update(adjusted_profit: item.result_price * seller_info.commission_rate)
    end
  end
end
