# == Schema Information
#
# Table name: policy_shipping_fees
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(FALSE)
#  current       :boolean          default(FALSE)
#  default       :boolean          default(FALSE)
#  delivery_type :string(255)
#  feature       :string(255)
#  fee           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  country_id    :bigint           not null
#
# Indexes
#
#  index_policy_shipping_fees_on_country_id  (country_id)
#
class Policy::ShippingFee < NationRecord
  after_save :set_current

  belongs_to :country

  scope :default, -> {where(default: true)}
  scope :active, -> {where(active: true)}

  def self.delivery_types
    pluck(:delivery_type)
  end

  def self.features
    pluck(:feature)
  end

  def set_current
    transaction do
      where(current: true).update_all(current: false)

      types = self.delivery_types
      features = self.features
      types.each do |type|
        features.each do |feature|
          policy = where(type: type, feature: feature).order(created_at: :asc).last
          policy.update(current: true) if policy
        end
      end
    end
  end
end
