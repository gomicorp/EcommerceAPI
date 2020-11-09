# == Schema Information
#
# Table name: order_infos
#
#  id              :bigint           not null, primary key
#  admin_memo      :text(65535)
#  finished        :boolean
#  ordered_at      :datetime
#  payment_status  :string(255)
#  shipping_status :string(255)
#  status          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cart_id         :integer
#  channel_id      :bigint           not null
#  country_id      :bigint
#  enc_id          :string(255)
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

  belongs_to :cart
  belongs_to :channel
  has_one :ship_info, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :user, through: :cart
  has_many :items, through: :cart
  has_many :product_options, through: :items, source: :product_option
  has_many :adjustments, class_name: 'Adjustment'

  # ===============================================
  has_many :order_info_brands, class_name: 'OrderInfoBrand', dependent: :delete_all
  has_many :brands, through: :order_info_brands
  # ===============================================

  validates_presence_of :cart_id, :enc_id
  validates_uniqueness_of :cart_id, :enc_id

  delegate :order_status, to: :cart
  # alias_attribute :status, :order_status
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

  def update_status(status=nil)
    transaction do
      payment_status = payment.current_status
      shipping_status = ship_info.current_status

      update(shipping_status: shipping_status, payment_status: payment_status)
      update(status: status) unless status.nil?
    end

  end
end
