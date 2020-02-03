class ProductOption < ApplicationRecord
  belongs_to :option_group, class_name: 'ProductOptionGroup', dependent: :destroy, foreign_key: :product_option_group_id
  has_many :barcode_options
  has_many :barcodes, through: :barcode_options

  has_many :bridges, class_name: 'ProductOptionBridge'

  delegate :product, to: :option_group

  enum discount_type: %i[no const ratio]

  def title
    "#{option_group.name}: #{name}"
  end

  def base_price
    @base_price ||= bridges.map(&:price).sum #product.price + additional_price
  end

  def retail_price
    @retail_price ||= base_price + price_change
  end

  # TODO: 할인/추가 금액 관련. 리펙토링 필요.
  def price_change
    @price_change = 0
    case discount_type
    when 'const'
      @price_change -= discount_amount
    when 'ratio'
      @price_change -= (base_price * discount_amount)
    end
    @price_change
  end

  #=============================
  # 현재 존재하는 옵션들의 unit count를 + 기준으로 구하여 옵션명에 반영하는 함수
  #=============================
  def self.set_all_unit_count
    multi_unit_options = ProductOption.where('name LIKE ?', '%+%')
    multi_unit_options.each do |opt|
      opt.barcodes.first.unit_count!(opt.name.count('+') + 1)
    end
  end

end
