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
