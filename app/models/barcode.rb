# == Schema Information
#
# Table name: barcodes
#
#  id           :bigint           not null, primary key
#  cancelled_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cart_item_id :bigint
#  product_id   :bigint
#
# Indexes
#
#  index_barcodes_on_cart_item_id  (cart_item_id)
#  index_barcodes_on_product_id    (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_item_id => cart_items.id)
#  fk_rails_...  (product_id => products.id)
#
class Barcode < ApplicationRecord
  belongs_to :product, dependent: :destroy

  has_many :barcode_options
  has_many :product_options, through: :barcode_options

  belongs_to :cart_item, optional: true, counter_cache: :barcode_count

  scope :alive, -> { where(cart_item_id: nil) }
  scope :finished, -> { where.not(cart_item_id: nil) }
  scope :options_with, ->(*option_ids) { where(id: BarcodeOption.barcode_ids_for(*option_ids)) }
  scope :cart_with, ->(cart_id) { includes(:cart_item).where(cart_item: CartItem.where(cart_id: cart_id)) }
  scope :not_cancelled, -> { where(cancelled_at: nil) }

  scope :ordered_at, ->(range) {
    includes(:cart_item).where(
      cart_item: CartItem.includes(:cart).where(
        cart: Cart.includes(:order_info).where(
          order_info: OrderInfo.sold.where(ordered_at: range)
        )
      )
    )
  }
  scope :price_sum, -> { includes(:product, :product_options).map(&:price).sum }

  delegate :order_info, to: :cart_item, allow_nil: true
  delegate :ordered_at, to: :order_info, allow_nil: true

  after_save :update_product_cache

  def price
    product.price + product_options.sum(:additional_price)
  end

  def cancel!
    update(cancelled_at: Time.zone.now)
  end

  def remove!
    barcode_options.each(&:delete)
    delete if barcode_options.reload.count.zero?
  end

  protected

  def update_product_cache
    product.update_barcode_cache
  end
end
