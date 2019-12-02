class ShipInfo < ApplicationRecord
  enum ship_type: %i[normal express]

  FEE_TABLE = {
    normal: 30,
    express: 50
  }.freeze # standard on THB

  belongs_to :order_info
  has_one :user, through: :order_info

  validates_presence_of :order_info
  validates_presence_of :receiver_name, :receiver_tel, :receiver_email
  validates_presence_of :loc_state, :loc_city, :loc_detail

  scope :order_status, ->(status_name) { includes(:order_info).where(order_info: OrderInfo.order_status(status_name)) }

  def self.fee_table(ship_type)
    FEE_TABLE[ship_type.to_sym]
  end

  def delivery_amount
    FEE_TABLE[ship_type] || FEE_TABLE[:normal]
  end

  def address
    [loc_detail, loc_city, loc_state].join(', ')
  end
end
