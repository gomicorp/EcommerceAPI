# == Schema Information
#
# Table name: product_options
#
#  id                        :bigint           not null, primary key
#  additional_price          :integer          default(0), not null
#  base_price                :integer          default(0), not null
#  channel_code              :string(255)
#  discount_amount           :float(24)        default(0.0), not null
#  discount_price            :integer          default(0), not null
#  discount_type             :integer          default("no"), not null
#  is_active                 :boolean          default(FALSE), not null
#  name                      :string(255)
#  price_change              :integer          default(0), not null
#  retail_price              :integer          default(0), not null
#  seller_shipping           :boolean          default(FALSE), not null
#  seller_warehouse_key      :string(255)
#  seller_warehouse_ship_fee :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  channel_id                :bigint           not null
#  product_option_group_id   :bigint
#
# Indexes
#
#  index_product_options_on_channel_id               (channel_id)
#  index_product_options_on_product_option_group_id  (product_option_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_option_group_id => product_option_groups.id)
#
class ProductOption < ApplicationRecord
  include ChannelRecordable
  belongs_to :option_group, class_name: 'ProductOptionGroup', foreign_key: :product_option_group_id
  has_many :barcode_options
  has_many :barcodes, through: :barcode_options

  has_many :bridges, class_name: 'ProductOptionBridge'

  # delegate :product, to: :option_group
  has_one :product, foreign_key: :default_option_id, dependent: :nullify
  has_one :product_page, class_name: 'Product', through: :option_group, source: :product

  # ===============================================
  has_many :product_option_brands, class_name: 'ProductOptionBrand', dependent: :destroy
  has_many :brands, through: :product_option_brands
  # ===============================================

  enum discount_type: %i[no const ratio]

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: [false, nil]) }

  scope :products_with, ->(products) { where(option_group: ProductOptionGroup.where(product: products)) }

  after_save :after_save_propagation

  def unit_count
    bridges.map(&:unit_count).sum
  end

  def alive_entities_count
    bridges.map(&:alive_entities_count).sum
  end

  def title
    parent_name = [product_page.translate.title, option_group.name].map(&:presence).compact.join(' ')
    "#{parent_name}: #{name}"
  end

  def available_quantity
    bridges.group(:connectable_id, :connectable_type).count.map do |keys, count|
      Object.const_get(keys[1]).find(keys[0]).available_quantity / count
    end.min.to_i
  end

  def sold_out?
    available_quantity.zero?
  end

  def activable?
    !bridges.map(&:active).any? false
  end

  alias can_be_active? activable?

  ##=============================
  ## 현재 존재하는 옵션들의 unit count 를 + 기준으로 구하여 옵션명에 반영하는 함수
  ##=============================
  # def self.set_all_unit_count
  #   multi_unit_options = ProductOption.where('name LIKE ?', '%+%')
  #   multi_unit_options.each do |opt|
  #     opt.barcodes.first.unit_count!(opt.name.count('+') + 1)
  #   end
  # end

  def connect_with(connectable)
    bridges.create(connectable: connectable)
  end

  def disconnect_with(connectable)
    bridges.destroy bridges.find_by(connectable: connectable)
  end

  def items
    ## V1
    # ProductItem.where(bridges: ProductOptionBridge.where(product_option: self))
    # bridges.joins_connectable.where(connectable: [ProductItem, ProductCollection])

    ## V2
    # items = bridges.where(connectable_type: 'ProductCollection').joins_connectable.map { |b| b.connectable.items }
    # items += bridges.where(connectable_type: 'ProductItem').connectables
    # items.flatten

    @items ||= ProductItem.product_option_with self
  end


  ## ===== before calculator =====

  # def base_price
  #   @base_price ||= bridges.map(&:selling_price).sum # product.price + additional_price
  # end
  #
  # # 추가 가격 (column)
  # # def additional_price
  # #   # stuff
  # # end
  # #
  # # 할인 금액 => 1. 정액 | 정률 (column)
  # # def discount_amount
  # #   # stuff
  # # end
  #
  # # 할인 금액 => 2. 현금액수
  # def discount_price
  #   case discount_type
  #   when 'const'
  #     discount_amount
  #   when 'ratio'
  #     base_price * discount_amount
  #   else
  #     0
  #   end
  # end
  #
  # # 변동액수
  # def price_change
  #   additional_price - discount_price
  # end
  #
  # def retail_price
  #   base_price + price_change
  # end

  # alias price retail_price


  ## ===== Calculators =====

  def calc_base_price
    bridges.map(&:selling_price).sum
  end

  # 할인 금액 => 2. 현금액수
  def calc_discount_price
    case discount_type
    when 'const'
      discount_amount
    when 'ratio'
      base_price * discount_amount
    else
      0
    end
  end

  # 변동액수
  def calc_price_change
    additional_price - discount_price
  end

  def calc_retail_price
    base_price + price_change
  end

  def calculate_price_columns
    self.base_price = calc_base_price
    self.discount_price = calc_discount_price
    self.price_change = calc_price_change
    self.retail_price = calc_retail_price

    print_columns :base_price, :discount_price, :price_change, :retail_price
  end


  ## ===== ActiveRecord Callbacks =====

  def after_save_propagation
    # stuff
  end
end
