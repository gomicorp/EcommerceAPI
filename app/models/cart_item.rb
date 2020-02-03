# frozen_string_literal: true

class CartItem < ApplicationRecord
  include CounterCacheResettable

  resettable_counter_for :barcodes

  belongs_to :cart
  belongs_to :product
  has_many :barcodes, dependent: :nullify
  has_many :product_options, -> { distinct }, through: :barcodes

  belongs_to :product_option

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
end
