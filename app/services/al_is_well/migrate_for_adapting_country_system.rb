module AlIsWell
  module MigrateForAdaptingCountrySystem
    def self.call
      ApplicationRecord.transaction do
        Country.migrate_input_seed_data

        national_models = [
          Brand,
          Adjustment,
          ProductCollection,
          ProductItemGroup,
          ProductItem
        ]

        national_models.each(&:migrate_original_record_to_thai_record)
      end
    end
  end
end
