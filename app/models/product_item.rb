class ProductItem < NationRecord
  extend_has_many_attached :images

  belongs_to :item_group, class_name: 'ProductItemGroup', foreign_key: :item_group_id
  has_one :brand, class_name: 'Brand', through: :item_group
  has_one :company, class_name: 'Company', through: :brand

  has_many :options, class_name: 'ProductOption', through: :product_item_product_options

  has_many :adjustment_product_items
  has_many :adjustments, through: :adjustment_product_items
  has_many :barcodes, class_name: 'ProductItemBarcode'

  has_many :bridges, class_name: 'ProductOptionBridge', as: :connectable
  has_many :product_options, through: :bridges

  has_one :zohomap, as: :zohoable

  def accumulated_amounts
    @accumulated_amounts ||= adjustments.where.not(reason: 'Order').sum(:amount)
  end

  def exports_quantity(from = nil, to = nil, channel = nil)
    query = {}
    query[:created_at] = from.to_date..to.to_date if from && to
    query[:channel] = channel if channel && channel.to_s != 'All'
    Math.abs(adjustments.where(reason: 'Order').where(query).sum(:amount))
  end

  private

  def update_counter_cache
    update_column(:alive_barcodes_count, barcodes.alive.count)
  end
end
