module Shipping
  class Courier < ShippingModelImitation
    use_adapter 'ParcelTrackingAdapter::AftershipAdapter'

    # base attributes
    attribute :slug
    attribute :name
    attribute :phone
    attribute :other_name
    attribute :web_url

    # fields set
    attribute :required_fields
    attribute :optional_fields

    # languages
    attribute :default_language
    attribute :support_languages

    # etc
    attribute :service_from_country_iso3

    def self.all
      adapter.get_couriers.map { |data| new data }
    end
  end
end
