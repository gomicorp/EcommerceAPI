# == Schema Information
#
# Table name: ship_infos
#
#  id             :bigint           not null, primary key
#  loc_city       :string(255)
#  loc_detail     :text(65535)
#  loc_district   :string(255)
#  loc_state      :string(255)
#  postal_code    :string(255)
#  receiver_email :string(255)
#  receiver_name  :string(255)
#  receiver_tel   :string(255)
#  ship_amount    :integer          default(0), not null
#  ship_type      :integer          default("normal"), not null
#  user_memo      :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_info_id  :integer
#
class ShipInfo < ApplicationRecord

  STATUS = %w[
    ship_prepare
    ship_ing
    ship_complete
    return_request
    return_processing
    return_complete
  ].freeze
  act_as_status_loggable status_list: STATUS.to_echo

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
end
