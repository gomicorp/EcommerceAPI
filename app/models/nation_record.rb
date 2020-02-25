class NationRecord < ApplicationRecord
  self.abstract_class = true

  default_scope -> {
    if ApplicationRecord.country_code
      where(country: Country.find_by(short_name: ApplicationRecord.country_code))
    end
  }

  belongs_to :country
end
