# == Schema Information
#
# Table name: product_collections
#
#  id                         :bigint           not null, primary key
#  active                     :boolean          default(FALSE), not null
#  cost_price                 :integer          default(0), not null
#  gomi_standard_product_code :string(255)      not null
#  name                       :string(255)
#  selling_price              :integer          default(0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  country_id                 :bigint
#
# Indexes
#
#  index_product_collections_on_country_id                  (country_id)
#  index_product_collections_on_gomi_standard_product_code  (gomi_standard_product_code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class ProductCollection < NationRecord
  include UseGomiStandardProductCode

  has_many :elements, class_name: 'ProductCollectionElement'
  has_many :items, class_name: 'ProductItem', through: :elements, source: :product_item
  has_many :lists, class_name: 'ProductCollectionList', foreign_key: :collection_id
  has_one :zohomap, as: :zohoable
  has_many :bridges, class_name: 'ProductOptionBridge', as: :connectable, dependent: :destroy

  validates :name, presence: true

  scope :item_with, ->(product_item) { includes(:elements).where(elements: ProductCollectionElement.where(product_item: product_item)) }
  scope :product_option_with, ->(product_options) { where(bridges: ProductOptionBridge.where(product_option: product_options)) }

  after_save :after_save_propagation

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

  def all_items_active?
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
  # alias price selling_price


  ## ===== Calculators =====

  def calc_cost_price
    lists.sum(&:cost_price)
  end

  def calc_selling_price
    lists.sum(&:selling_price)
  end

  def calculate_price_columns
    self.cost_price = calc_cost_price
    self.selling_price = calc_selling_price

    print_columns :cost_price, :selling_price
  end

  private
  ## ===== ActiveRecord Callbacks =====

  def after_save_propagation
    bridges.each do |bridge|
      bridge.calculate_price_columns
      bridge.save
    end
  end
end
