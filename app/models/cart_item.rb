# frozen_string_literal: true

# == Schema Information
#
# Table name: cart_items
#
#  id                        :bigint           not null, primary key
#  barcode_count             :integer          default(0), not null
#  captured                  :boolean          default(FALSE), not null
#  captured_additional_price :integer          default(0), not null
#  captured_base_price       :integer          default(0), not null
#  captured_discount_price   :integer          default(0), not null
#  captured_price_change     :integer          default(0), not null
#  captured_retail_price     :integer          default(0), not null
#  option_count              :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cart_id                   :bigint
#  product_id                :bigint
#  product_option_id         :bigint           default(0), not null
#
# Indexes
#
#  index_cart_items_on_cart_id            (cart_id)
#  index_cart_items_on_product_id         (product_id)
#  index_cart_items_on_product_option_id  (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#  fk_rails_...  (product_id => products.id)
#
class CartItem < ApplicationRecord
  include CounterCacheResettable

  resettable_counter_for :barcodes

  ##========================================
  # LEGACY
  belongs_to :product, optional: true
  has_many :barcodes, dependent: :nullify
  has_many :product_options, -> { distinct }, through: :barcodes
  ##========================================

  belongs_to :cart
  belongs_to :product_option
  delegate :product_page, to: :product_option
  delegate :unit_count, to: :product_option
  has_many :bridges, through: :product_option

  has_many :cart_item_barcodes, dependent: :destroy
  has_many :product_item_barcodes, class_name: 'ProductItemBarcode', through: :cart_item_barcodes
  has_one :cancelled_tag, class_name: 'CartItemCancelledTag'

  has_one :order_info, through: :cart

  has_one :item_sold_paper, class_name: 'Sellers::ItemSoldPaper', foreign_key: :item_id, dependent: :destroy

  scope :cancelled, -> { where(cancelled_tag: CartItemCancelledTag.all) }
  scope :not_cancelled, -> { where.not(cancelled_tag: CartItemCancelledTag.all) }

  scope :eager_resources, -> { includes(:cancelled_tag, cart: { order_info: :payment }) }
  scope :cancelled_at, ->(range) { includes(:cancelled_tag).where(cancelled_tag: CartItemCancelledTag.where(cancelled_at: range)) }
  scope :ordered_at, ->(range) { includes(cart: :order_info).where(cart: Cart.sold.where(order_info: OrderInfo.where(ordered_at: range))) }
  scope :paid_at, ->(range) { eager_resources.not_cancelled.where(carts: { order_infos: { payments: { paid: true, paid_at: range } } }) }
  # delegate :order_info, to: :cart, allow_nil: true
  #
  # def _barcode_count
  #   @_barcode_count ||= barcodes.length
  # end

  zombie :product_option

  delegate :page_title, to: :zombie_product_option
  delegate :title, to: :zombie_product_option, prefix: :option # option_title
  delegate :name, to: :zombie_product_option, prefix: :option # option_name
  delegate :thumbnail, to: :product_page, prefix: :page

  # 단위 정가 & 합계
  delegate :base_price, to: :zombie_product_option
  def base_price_sum
    option_count * (captured ? captured_base_price : base_price)
  end

  # 구성 품목 수량 & 합계
  # A.K.A. EA (e.g. 10 EA)
  # 몇 개의 ProductItem 재고단위로 구성되었는가.
  delegate :unit_count, to: :zombie_product_option
  def unit_count_sum
    option_count * unit_count
  end

  # 단위 변동가 & 합계
  # 일반적인 경우, 음수값을 가짐
  delegate :price_change, to: :zombie_product_option
  def price_change_sum
    option_count * (captured ? captured_price_change : price_change)
  end

  # 합산 가격
  def result_price
    base_price_sum + price_change_sum
  end

  # def unit_price
  #   option_count.zero? ? 0 : product_option.retail_price
  # end

  # def price_sum
  #   option_count * product_option.base_price
  # end

  # # 할인 가액
  # def discount_amount
  #   option_count * product_option.discount_price
  # end

  # def retail_price_sum
  #
  # end

  def cancel!
    CartItemCancelledTag.create(cart_item: self, cancelled_at: Time.zone.now).persisted? unless cancelled
    true
  end

  def cancelled
    cancelled_tag.present?
  end

  alias cancelled? cancelled

  def cancelled_rollback
    cancelled_tag.destroy!
  end

  def should_expired?
    barcode_items = []
    product_item_barcodes.each { |barcode| barcode_items << barcode.product_item }
    bridge_items = product_option.bridges.map(&:items) * option_count
    return true if barcode_items.flatten.pluck(:id).sort != bridge_items.flatten.pluck(:id).sort
    return true unless product_option.is_active?
    return true if updated_at < 3.days.ago

    false
  end

  def expire!
    ActiveRecord::Base.transaction do
      product_item_barcodes.map(&:disexpire!)
      destroy
    end
  end
  #def similar_barcodes
  #  Barcode.options_with(product_options.ids)
  #end

  def item_count(product_item)
    product_option.items.count(product_item) * option_count
  end

  def self.item_count(product_item)
    all.map { |cart_item| cart_item.item_count(product_item) }.sum
  end

  def capture_price_fields!
    capture_price_fields
    save!
  end

  def capture_price_fields
    po = zombie_product_option
    tap do |item|
      item.captured_base_price = po.base_price
      item.captured_discount_price = po.discount_price
      item.captured_additional_price = po.additional_price
      item.captured_price_change = po.price_change
      item.captured_retail_price = po.retail_price
      item.captured = true
    end
  end

  def write_sold_paper(seller)
    update(item_sold_paper:
             Sellers::ItemSoldPaper.new(
               adjusted_profit: result_price * seller.commission_rate,
               seller_info: seller
             )
    )
  end

  # def _barcode_count
  #   @_barcode_count ||= barcodes.length
  # end
  #
  # def unit_price
  #   _barcode_count.zero? ? 0 : barcodes.first&.price.to_i
  # end
  #
  # def price_sum
  #   _barcode_count * unit_price
  # end
  #
  # def self.migrate_cart_items
  #   CartItem.where('created_at > ?', 4.months.ago).each do |cart_item|
  #     cart_item.product_option = cart_item.product_options.first
  #     cart_item.save!
  #   end
  # end
end
