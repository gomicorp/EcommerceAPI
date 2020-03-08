class NationRecord < ApplicationRecord
  self.abstract_class = true

  belongs_to :country, optional: true

  default_scope -> { send(country_code) }
  scope :th, -> { unscoped.includes(:country).where(country: Country.th) }
  scope :vn, -> { unscoped.includes(:country).where(country: Country.vn) }
  scope :undef, -> { unscoped.includes(:country).where(country: Country.undef) }
  scope :at, ->(key) { unscoped.includes(:country).where(country: Country.at(key)) }

  after_initialize :callback_set_default_country
  before_save :callback_attaching_country

  def self.migrate_original_record_to_thai_record
    unscoped.where(country_id: nil).update_all(country_id: Country.th.id)
  end

  private

  def callback_set_default_country
    self.country_id ||= default_country.id
  end

  def callback_attaching_country
    callback_set_default_country
  end

  def default_country
    @default_country ||= Country.send(self.class.country_code)
  end
end
