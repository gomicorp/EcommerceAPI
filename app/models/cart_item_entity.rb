# == Schema Information
#
# Table name: cart_item_entities
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  cart_item_id           :bigint           not null
#  product_item_entity_id :bigint           not null
#
# Indexes
#
#  index_cart_item_entities_on_cart_item_id            (cart_item_id)
#  index_cart_item_entities_on_product_item_entity_id  (product_item_entity_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_item_id => cart_items.id)
#  fk_rails_...  (product_item_entity_id => product_item_entities.id)
#
class CartItemEntity < ApplicationRecord
  belongs_to :cart_item, class_name: 'CartItem'
  belongs_to :product_item_entity, class_name: 'ProductItemEntity'
end
