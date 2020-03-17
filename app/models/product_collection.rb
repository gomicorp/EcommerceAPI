class ProductCollection < NationRecord
  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements, source: :product_item
  has_many :lists, class_name: 'ProductCollectionList', foreign_key: :collection_id
  has_one :zohomap, as: :zohoable
  has_many :bridges, class_name: 'ProductOptionBridge', as: :connectable, dependent: :destroy

  validates :name, presence: true

  scope :item_with, ->(product_item) { includes(:elements).where(elements: ProductCollectionElement.where(product_item: product_item)) }

  def group_by_alive
    items.group(:id, :alive_barcodes_count).count
  end

  def available_quantity
    group_by_alive.map { |keys, count| keys[1] / count }.min.to_i
  end

  def unit_count
    items_count
  end

  def items_count
    @items_count ||= items.count
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
