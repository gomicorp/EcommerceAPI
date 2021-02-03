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
  has_many :product_options, through: :bridges

  validates :name, presence: true
  validate :check_active_can_be_change, if: :active_changed?

  scope :item_with, ->(product_item) { includes(:elements).where(elements: ProductCollectionElement.where(product_item: product_item)) }
  scope :product_option_with, ->(product_options) { where(bridges: ProductOptionBridge.where(product_option: product_options)) }

  accepts_nested_attributes_for :lists, allow_destroy: true, reject_if: ->(attributes) {
    return false if attributes['_custom_destroy'] == 'false'

    if attributes['_custom_destroy'] == 'true'
      list = ProductCollectionList.find(attributes['id'])
      list.custom_destroy
    end
  }

  before_save :before_save_calculate
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
    items.group(:id, :alive_entities_count).count
  end

  def available_quantity
    group_by_alive.map { |keys, count| keys[1] / count }.min.to_i
  end

  def entities_count
    @entities_count ||= items.sum(:entities_count)
  end

  def all_items_active?
    items.where(active: false).empty?
  end

  def alive_entities_count
    items.sum(:alive_entities_count)
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

  def before_save_calculate
    calculate_price_columns
  end

  def after_save_propagation
    bridges.each do |bridge|
      bridge.calculate_price_columns
      bridge.save
    end
  end


  ## ===== ActiveRecord Validations =====

  def check_active_can_be_change
    return unless active_changed?

    if active_was == false && active == true
      ## 활성화 할 수 있는지 체크

      # 연결된 단품이 없는 경우
      errors.add(:active, "cannot be active. No 'product items' connected.") if items.count.zero?

      # 연결된 단품 중에 비활성화된 것이 포함된 경우
      errors.add(:active, "cannot be active. Some of the connected 'product items' are not active.") if items.where(active: false).any?

    elsif active_was == true && active == false
      ## 비활성화 할 수 있는지 체크

      # 활성화된 상품옵션이 연결되어 있는 경우
      errors.add(:active, "cannot be inactive. Some of the connected 'product options' are active.") if product_options.active.any?
    end
  end
end
