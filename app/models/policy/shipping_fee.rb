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
