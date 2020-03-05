class NationRecord < ApplicationRecord
  self.abstract_class = true

  belongs_to :country, optional: true

  default_scope -> { th }
  scope :th, -> { unscoped.left_joins(:country).where(countries: { short_name: 'th' }) }
  scope :vn, -> { unscoped.left_joins(:country).where(countries: { short_name: 'vn' }) }
  scope :undef, -> { unscoped.left_joins(:country).where(countries: { short_name: nil }) }
  scope :at, ->(key) { unscoped.left_joins(:country).where(countries: { short_name: key }) }

  before_save :callback_attaching_country

  def self.migrate_original_record_to_thai_record
    unscoped.where(country_id: nil).update_all(country_id: Country.th.id)
  end

  private

  def callback_attaching_country
    self.country ||= Country.th
  end
end
