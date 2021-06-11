# == Schema Information
#
# Table name: payments
#
#  id                    :bigint           not null, primary key
#  amount                :integer
#  cancel_message        :text(16777215)
#  cancelled             :boolean          default(FALSE), not null
#  delivery_amount       :integer
#  expire_at             :datetime
#  paid                  :boolean
#  paid_at               :datetime
#  pay_method            :string(255)
#  total_discount_amount :integer
#  total_price_sum       :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  charge_id             :string(255)
#  order_info_id         :bigint
#
# Indexes
#
#  index_payments_on_order_info_id  (order_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_info_id => order_infos.id)
#
class Payment < NationRecord

  STATUS = %w[
    pay_wait
    paid
    refund_request
    refund_complete
    refund_reject
  ].freeze
  act_as_status_loggable status_list: STATUS.to_echo

  PAY_METHOD = %i[
    bank
    cod
    omise
    iamport
    momo_pay
    vn_pay
  ].freeze

  PAY_METHOD_VIA_PG = %i[
    omise
    iamport
    momo_pay
    vn_pay
  ]

  extend_has_many_attached :pay_slips
  belongs_to :order_info
  has_one :user, through: :order_info

  validates_presence_of :order_info

  # Account Data is the most important!!
  validates_presence_of(
    :amount,
    :total_price_sum,
    :total_discount_amount,
    :delivery_amount
  )

  scope :order_status, ->(status_name) {
    includes(:order_info).where(order_info: OrderInfo.stage_in(status_name))
  }
  # scope :pay_slips_attached, -> { left_joins(:pay_slips_attachments).where('active_storage_attachments.id is NOT NULL') }
  # scope :pay_slips_unattached, -> { left_joins(:pay_slips_attachments).where('active_storage_attachments.id is NULL') }

  def self.available_status
    STATUS
  end

  # Decorate method
  def expire_warning_message
    return unless pay_method == 'bank'
    return "<span class=\"fas fa-stopwatch\"></span> <span class=\"d-inline-block\"><b>#{I18n.t('create_payment_page.message.overdue')}</b></span>".html_safe if overdue?

    case order_info.order_status
    when 'pay'
      "<span class=\"fas fa-stopwatch\"></span> #{until_msg} <span class='d-inline-block'><b>#{I18n.l(expire_at, format: :expire_datetime)}</b> (D#{d_day})</span>".html_safe unless paid
    when 'cancel-request'
      I18n.t('cart.order_status_message.cancel-request').html_safe
    when 'cancel-complete'
      I18n.t('cart.order_status_message.cancel-complete').html_safe
    else
      ''
    end
  end

  def until_msg
    case I18n.locale
    when :en
      'Until'
    when :ko
      '입금마감'
    when :th
      'ชำระได้จนถึง'
    end
  end

  def left_time
    return unless expire_at

    Time.zone.now - expire_at
  end

  def d_day
    (left_time / 1.day).round
  end

  def overdue?
    left_time.positive?
  end

  def write_self!
    write_self
    save!
  end

  def write_self
    assign_attributes(payment_account_data)

    assign_attributes(payment_expire_data) if pay_method == 'bank'
  end

  def build_paid
    assign_attributes(
      paid: true,
      paid_at: DateTime.now
    )
  end

  private

  def cart
    @cart ||= order_info.cart
  end

  def payment_account_data
    {
      amount: cart.final_price,
      total_price_sum: cart.price_sum,
      total_discount_amount: cart.discount_amount,
      delivery_amount: cart.delivery_amount
    }
  end

  def payment_expire_data
    {
      paid: false,
      expire_at: Time.zone.now + 48.hours
    }
  end
end
