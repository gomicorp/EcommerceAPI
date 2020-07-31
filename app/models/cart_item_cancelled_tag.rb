# == Schema Information
#
# Table name: cart_item_cancelled_tags
#
#  id           :bigint           not null, primary key
#  cancelled_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cart_item_id :bigint           not null
#
# Indexes
#
#  index_cart_item_cancelled_tags_on_cart_item_id  (cart_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_item_id => cart_items.id)
#
class CartItemCancelledTag < ApplicationRecord
  belongs_to :cart_item
end
