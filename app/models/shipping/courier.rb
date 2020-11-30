module Shipping
  class Courier < ShippingModel
    attr_reader :slug, :name, :phone, :other_name, :web_url,  # base attributes
      :required_fields, :optional_fields,           # fields set
      :default_language, :support_languages,        # languages
      :service_from_country_iso3                    # etc

    ENDPOINTS = {
      all: { path: '/couriers', entries: 'couriers' }
    }.freeze

    private

    def parse_data
      @slug = data.dig(:slug)
      @name = data.dig(:name)
      # ...
    end
  end
end
