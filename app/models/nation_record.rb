class NationRecord < ApplicationRecord
  self.abstract_class = true

  belongs_to :country, optional: true

  default_scope -> { send(country_code.to_sym) }
  scope :th, -> { unscoped.includes(:country).where(country: Country.th) }
  scope :vn, -> { unscoped.includes(:country).where(country: Country.vn) }
  scope :undef, -> { unscoped.includes(:country).where(country: Country.undef) }
  scope :at, ->(key) { unscoped.includes(:country).where(country: Country.at(key)) }

  before_save :callback_attaching_country

  def self.migrate_original_record_to_thai_record
    unscoped.where(country_id: nil).update_all(country_id: Country.th.id)
  end

  private

  def callback_attaching_country
    self.country ||= Country.send(ENV['APP_COUNTRY'])
  end
end
