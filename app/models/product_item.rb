# == Schema Information
#
# Table name: product_items
#
#  id                   :bigint           not null, primary key
#  active               :boolean          default(FALSE), not null
#  alive_barcodes_count :integer          default(0), not null
#  barcodes_count       :integer          default(0), not null
#  cost_price           :integer          default(0), not null
#  name                 :string(255)
#  selling_price        :integer          default(0), not null
#  serial_number        :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  country_id           :bigint
#  item_group_id        :bigint           not null
#
# Indexes
#
#  index_product_items_on_country_id     (country_id)
#  index_product_items_on_item_group_id  (item_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (item_group_id => product_item_groups.id)
#
class ProductItem < NationRecord
  extend_has_many_attached :images

  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :item_group_id
  has_one :brand, class_name: 'Brand', through: :item_group
  has_one :company, class_name: 'Company', through: :brand

  has_many :options, class_name: 'ProductOption', through: :product_item_product_options

  has_many :adjustment_product_items
  has_many :adjustments, through: :adjustment_product_items
  has_many :barcodes, class_name: 'ProductItemBarcode', dependent: :destroy

  has_many :bridges, class_name: 'ProductOptionBridge', as: :connectable, dependent: :destroy
  has_many :product_options, through: :bridges

  has_many :product_collection_elements
  has_many :collections, through: :product_collection_elements

  has_one :zohomap, as: :zohoable

  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :selling_price, presence: true
  validates :cost_price, presence: true

  scope :activated, -> { where(active: true) }

  scope :product_option_with, lambda { |product_options|
    where(
      bridges: ProductOptionBridge.where(product_option: product_options)
    ).or(
      where(
        product_collection_elements: ProductCollectionElement.where(
          collection: ProductCollection.product_option_with(product_options)
        )
      )
    )
  }

  after_save :after_save_propagation


  # => Counter Cache Pseudo Code
  # stuff
  def barcodes_remain_count
    barcodes.remain.count
  end

  def brand_name
    brand.translate.name
  end

  def unit_count
    1
  end

  def available_quantity
    alive_barcodes_count / unit_count
  end

  def activable?
    !active && available_quantity.positive? && !adjustments.empty?
  end


  # ===== START Gomisa ======
  #
  def accumulated_amounts
    @accumulated_amounts ||= adjustments.where.not(reason: 'Order').sum(:amount)
  end
  #
  def exports_quantity(from = nil, to = nil, channel = nil)
    query = {}
    query[:created_at] = from.to_date..to.to_date if from && to
    query[:channel] = channel if channel && channel.to_s != 'All'
    Math.abs(adjustments.where(reason: 'Order').where(query).sum(:amount))
  end
  #
  # ===== END Gomisa =====


  private

  def update_counter_cache
    update_column(:alive_barcodes_count, barcodes.alive.count)
  end


  ## ===== ActiveRecord Callbacks =====

  def after_save_propagation
    collections.each do |collection|
      collection.calculate_price_columns
      collection.save
    end

    bridges.each do |bridge|
      bridge.calculate_price_columns
      bridge.save
    end
  end
end
