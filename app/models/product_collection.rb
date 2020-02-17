class ProductCollection < ApplicationRecord
  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements, source: :product_item
  has_many :lists, class_name: 'ProductCollectionList', foreign_key: :collection_id
  has_one :zohomap, as: :zohoable
  has_many :product_option_bridges, as: :connectable

  validates :name, presence: true

  def group_by_alive
    items.group(:id, :alive_barcodes_count).count
  end

  def available_quantity
    group_by_alive.map { |keys, count| keys[1] / count }.min.to_i
  end

  def selling_price
    lists.sum(&:selling_price)
  end

  def cost_price
    lists.sum(&:cost_price)
  end

  def active
    items.where(active: false).empty?
  end
end
