# frozen_string_literal: true

class CartItem < ApplicationRecord
  include CounterCacheResettable

  resettable_counter_for :barcodes

  belongs_to :cart
  belongs_to :product
  belongs_to :product_option
  has_many :cart_item_barcodes
  has_many :item_barcodes, class_name: 'ProductItemBarcode', through: :cart_item_barcodes
  has_one :cancelled_tag, class_name: 'CartItemCancelledTag'


  ##========================================
  # LEGACY
  has_many :barcodes, dependent: :nullify
  has_many :product_options, -> { distinct }, through: :barcodes
  ##========================================

  delegate :order_info, to: :cart, allow_nil: true

  def _barcode_count
    @_barcode_count ||= barcodes.length
  end

  def unit_price
    _barcode_count.zero? ? 0 : barcodes.first&.price.to_i
  end

  def price_sum
    _barcode_count * unit_price
  end

  def discount_amount
    0
  end

  def result_price
    price_sum - discount_amount
  end

  def similar_barcodes
    Barcode.options_with(product_options.ids)
  end

  def stat
    @stat = StatReportService.new(self)
  end

  def self.migrate_cart_items
    CartItem.where('created_at > ?', 4.months.ago).each do |cart_item|
      cart_item.product_option = cart_item.product_options.first
      cart_item.save!
    end
  end

end
