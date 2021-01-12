# == Schema Information
#
# Table name: product_collection_lists
#
#  item_id       :bigint           not null, primary key
#  collection_id :bigint           not null
#  unit_count    :bigint           default(0), not null
#
class ProductCollectionList < ApplicationRecord
  self.primary_key = :item_id

  belongs_to :collection, class_name: 'ProductCollection'
  belongs_to :item, class_name: 'ProductItem'

  def available_quantity
    item.alive_entities_count / unit_count
  end

  def cost_price
    item.cost_price * unit_count
  end

  def selling_price
    item.selling_price * unit_count
  end
end
