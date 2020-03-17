class ProductCollectionList < ApplicationRecord
  self.primary_key = :item_id

  belongs_to :collection, class_name: 'ProductCollection'
  belongs_to :item, class_name: 'ProductItem'

  def available_quantity
    item.alive_barcodes_count / unit_count
  end

  def cost_price
    item.cost_price * unit_count
  end

  def selling_price
    item.selling_price * unit_count
  end
end
