# == Schema Information
#
# Table name: order_infos
#
#  id                        :bigint           not null, primary key
#  admin_memo                :text(65535)
#  finished                  :boolean
#  order_confirmation_status :string(255)
#  ordered_at                :datetime
#  payment_status            :string(255)
#  shipping_status           :string(255)
#  status                    :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cart_id                   :integer
#  channel_id                :bigint           not null
#  country_id                :bigint
#  enc_id                    :string(255)
#
# Indexes
#
#  index_order_infos_on_cart_id     (cart_id) UNIQUE
#  index_order_infos_on_channel_id  (channel_id)
#  index_order_infos_on_country_id  (country_id)
#  index_order_infos_on_enc_id      (enc_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class OrderInfo < NationRecord
  include ChannelRecordable

  STATUSES = %w[
    pay_wait
    paid
    ship_prepare
    ship_ing
    ship_complete
    refund_request
    refund_reject
    refund_complete
    cancel_request
    cancel_complete
    order_complete
  ].freeze
  NEGATIVE_STATUSES = %w[cancel_complete refund_complete].freeze

  enum status: STATUSES.to_echo

  belongs_to :cart
  belongs_to :channel
  has_one :ship_info, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :user, through: :cart
  has_one :order_confirmation, dependent: :destroy
  has_many :items, through: :cart
  has_many :product_options, through: :items, source: :product_option
  has_many :adjustments, class_name: 'Adjustment'
  has_many :sellers_papers, through: :items, source: :item_sold_paper

  # ===============================================
  has_many :order_info_brands, class_name: 'OrderInfoBrand', dependent: :destroy
  has_many :brands, through: :order_info_brands
  # ===============================================

  validates_presence_of :cart_id, :enc_id
  validates_uniqueness_of :cart_id, :enc_id


  # alias_attribute :status, :order_status
  delegate :delivery_amount, to: :ship_info, allow_nil: true
  delegate :amount, to: :payment, allow_nil: true
  delegate :pay_method, to: :payment, allow_nil: true

  scope :sold, -> { includes(:cart).where(cart: Cart.where(order_status: Cart::SOLD_STATUSES)) }
  scope :eager_index, -> { includes(:payment, :ship_info, cart: [:user, { items: { product_option: [:product_page, { option_group: :product }] } }]) }
  scope :stage_in, ->(stage) { where(status: stage) }
  scope :sellers_order, -> { includes(:items).where(cart: Cart.where(items: CartItem.sold_by_seller)) }

  def self.gen_enc_id
    [
      ENV['ORDER_ENC_ID_PREFIX'] || I18n.locale.upcase.to_s,
      Time.now.utc.strftime('%Y%m%d%H%M%S'), # yyyymmddhhmmss
      SecureRandom.hex(4).upcase
    ].join('-')
  end

  def sender_name
    cart.sender_name
  end

  def receiver_name
    ship_info.receiver_name
  end

  def first_product
    cart.items.first.product if cart.items.any?
  end

  def quantity
    cart.items.sum(:entity_count)
  end

  def update_status(status=nil)
    transaction do
      payment_status = payment.current_status&.code
      shipping_status = ship_info.current_status&.code
      order_confirmation_status = order_confirmation.current_status&.code

      update(
        shipping_status: shipping_status,
        payment_status: payment_status,
        order_confirmation_status: order_confirmation_status
      )
      update(status: status) unless status.nil?
    end
  end

  def sellers_items
    items.filter(&:item_sold_paper)
  end
end
