# == Schema Information
#
# Table name: ship_infos
#
#  id              :bigint           not null, primary key
#  carrier_code    :string(255)
#  loc_city        :string(255)
#  loc_detail      :text(65535)
#  loc_district    :string(255)
#  loc_state       :string(255)
#  postal_code     :string(255)
#  receiver_email  :string(255)
#  receiver_name   :string(255)
#  receiver_tel    :string(255)
#  ship_amount     :integer          default(0), not null
#  tracking_number :string(255)
#  user_memo       :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  fee_policy_id   :bigint
#  order_info_id   :integer
#
# Indexes
#
#  index_ship_infos_on_fee_policy_id  (fee_policy_id)
#
# Foreign Keys
#
#  fk_rails_...  (fee_policy_id => policy_shipping_fees.id)
#
class ShipInfo < ApplicationRecord

  FORWARD_STATUS = %w[
    ship_prepare
    ship_ing
    ship_complete
  ].freeze
  BACKWORD_STATUS = %w[
    return_request
    return_processing
    return_complete
  ].freeze
  STATUS = (FORWARD_STATUS + BACKWORD_STATUS).freeze
  act_as_status_loggable status_list: STATUS.to_echo

  enum ship_type: %i[normal express bulk_express free]

  CARRIERS = {
    alphafast: { name: 'alphaFast', url: 'https://www.alphafast.com/track', trackable: true },
    '800bestex': { name: 'Best Express', url: 'https://www.best-inc.co.th/track', trackable: true },
    'cj-korea-thai': { name: 'CJ Express', url: 'https://standardexpress.online/cj-logistics/', trackable: true },
    flash_express: { name: 'flash_express', url: 'https://www.flashexpress.co.th/tracking/', trackable: false },
    'j&t_express': { name: 'j&t_express', url: 'https://www.jtexpress.co.th/index/query/gzquery', trackable: false },
    'kerry-logistics': { name: 'Kerry Express', url: 'https://th.kerryexpress.com/th/track/', trackable: true },
    'ninjavan-thai': { name: 'Ninja Van', url: 'https://www.ninjavan.co/th-th/tracking', trackable: true },
    'thailand-post': { name: 'Thai Post', url: 'https://track.thailandpost.co.th/', trackable: true },
  }.freeze

  enum carrier_code: [*CARRIERS.keys].map(&:to_s).to_echo

  FEE_TABLE = {
    normal: 30,
    express: 50
  }.freeze # standard on THB

  DELIVERY_TYPES = %w[normal express cod free 2h]

  belongs_to :order_info
  has_one :user, through: :order_info
  belongs_to :fee_policy, class_name: 'Policy::ShippingFee'

  validates_presence_of :order_info
  validates_presence_of :receiver_name, :receiver_tel, :receiver_email
  validates_presence_of :loc_state, :loc_city, :loc_detail

  scope :order_status, ->(status_name) { includes(:order_info).where(order_info: OrderInfo.stage_in(status_name)) }
  scope :auto_trackable, -> { where(carrier_code: CARRIERS.filter { |_k, v| v[:trackable] }.keys) }

  def self.available_status
    STATUS
  end

  def self.fee_table(ship_type)
    FEE_TABLE[ship_type.to_sym]
  end

  def delivery_amount
    FEE_TABLE[ship_type] || FEE_TABLE[:normal]
  end

  def address
    [loc_detail, loc_city, loc_state].join(', ')
  end

  def trackable?
    self.class::CARRIERS.dig(carrier_code.to_sym, :trackable)
  end

end
