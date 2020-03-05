class OrderInfo < ApplicationRecord
  belongs_to :cart
  has_one :ship_info, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :user, through: :cart
  has_many :cart_items, through: :cart
  has_many :adjustments, class_name: 'Adjustment'

  validates_presence_of :cart_id, :enc_id
  validates_uniqueness_of :cart_id, :enc_id

  delegate :order_status, to: :cart
  # alias_attribute :status, :order_status
  alias_attribute :ordered_at, :created_at
  delegate :delivery_amount, to: :ship_info, allow_nil: true
  delegate :amount, to: :payment, allow_nil: true
  delegate :pay_method, to: :payment, allow_nil: true

  scope :order_status, ->(status_name) { includes(:cart).where(cart: Cart.public_send(status_name)) }
  scope :sold, -> { includes(:cart).where(cart: Cart.where(order_status: Cart::SOLD_STATUSES)) }
  scope :eager_index, -> { includes(:payment, :ship_info) }
  scope :stage_in, ->(stage) { includes(:cart).where(cart: Cart.send((stage || :all).to_sym)) }

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
    cart.items.sum(:barcode_count)
  end
end
