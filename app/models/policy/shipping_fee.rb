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
  after_create :set_current

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
      klass = self.class
      klass.where(current: true).update_all(current: false)

      types = klass.delivery_types
      features = klass.features
      countries = Country.all
      types.each do |type|
        features.each do |feature|
          countries.each do |country|
            policy = klass.where(delivery_type: type, feature: feature, country: country).order(created_at: :asc).last
            policy&.update(current: true)
          end
        end
      end
    end
  end
end
