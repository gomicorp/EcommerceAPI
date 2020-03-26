module AlIsWell
  module MigrateForAdaptingCountrySystem
    def self.call
      ApplicationRecord.transaction do
        Country.migrate_input_seed_data

        national_models = [
          Channel,
          OrderInfo,
          Brand,
          Adjustment,
          Product,
          ProductCollection,
          ProductItemGroup,
          ProductItem,
          Category,
          Banner::Home,
          Banner::Category,
        ]

        national_models.each(&:migrate_original_record_to_thai_record)
      end
    end
  end
end
