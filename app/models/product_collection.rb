### Calculate ProductCollection
#
## ===== source columns ======
#
## ===== calculated columns ======
# :cost_price
# :selling_price
#
class ProductCollection < NationRecord
  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements, source: :product_item
  has_many :lists, class_name: 'ProductCollectionList', foreign_key: :collection_id
  has_one :zohomap, as: :zohoable
  has_many :bridges, class_name: 'ProductOptionBridge', as: :connectable, dependent: :destroy

  validates :name, presence: true

  scope :item_with, ->(product_item) { includes(:elements).where(elements: ProductCollectionElement.where(product_item: product_item)) }
  scope :product_option_with, ->(product_options) { where(bridges: ProductOptionBridge.where(product_option: product_options)) }

  def brand
    items.first&.brand
  end

  def brand_name
    "#{brand.translate.name} ..."
  end

  def unit_count
    items_count
  end

  def items_count
    @items_count ||= items.count
  end

  def brands
    @brands ||= items.map(&:brand)
  end

  def group_by_alive
    items.group(:id, :alive_barcodes_count).count
  end

  def available_quantity
    group_by_alive.map { |keys, count| keys[1] / count }.min.to_i
  end

  def barcodes_count
    @barcodes_count ||= items.sum(:barcodes_count)
  end

  def active
    items.where(active: false).empty?
  end

  def alive_barcodes_count
    items.sum(:alive_barcodes_count)
  end


  ## ===== before calculator =====

  # def cost_price
  #   lists.sum(&:cost_price)
  # end
  #
  # def selling_price
  #   lists.sum(&:selling_price)
  # end
  alias price selling_price


  ## ===== Calculators =====

  def calc_cost_price
    lists.sum(&:cost_price)
  end

  def calc_selling_price
    lists.sum(&:selling_price)
  end

  def callback_calculate_price_columns
    self.cost_price = calc_cost_price
    self.selling_price = calc_selling_price
  end
end
