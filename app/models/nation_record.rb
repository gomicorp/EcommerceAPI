class NationRecord < ApplicationRecord
  self.abstract_class = true

  default_scope -> { where(country: Country.find_by(short_name: ApplicationRecord.country_code)) }

  belongs_to :country
end
