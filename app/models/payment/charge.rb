# == Schema Information
#
# Table name: payment_charges
#
#  id                 :bigint           not null, primary key
#  pg_name            :string(255)      not null
#  statement          :text(65535)
#  status             :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  country_id         :bigint
#  external_charge_id :string(255)
#  payment_id         :bigint
#
# Indexes
#
#  index_payment_charges_on_country_id  (country_id)
#  index_payment_charges_on_payment_id  (payment_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (payment_id => payments.id)
#
class Payment::Charge < NationRecord
  STATUS = %w[
    pending
    paid
    expired
    refunded
  ].freeze
  enum status: STATUS.to_echo

  belongs_to :payment

  def statement
    JSON.parse self[:statement] if self[:statement]
  end

end
