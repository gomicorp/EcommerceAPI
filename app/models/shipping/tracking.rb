module Shipping
  class Tracking < ShippingModelImitation
    use_adapter 'ParcelTrackingAdapter::AftershipAdapter'

    attribute :id
    attribute :tracking_number
    attribute :slug
    attribute :active
    attribute :tag
    attribute :subtag
    attribute :subtag_message
    attribute :title
    attribute :created_at
    attribute :updated_at
    attribute :last_updated_at

    attribute :tracked_count
    attribute :language
    attribute :customer_name
    attribute :delivery_time
    attribute :destination_country_iso3
    attribute :courier_destination_country_iso3
    attribute :custom_fields
    attribute :emails
    attribute :expected_delivery
    attribute :android
    attribute :ios
    attribute :note
    attribute :order_id
    attribute :order_id_path
    attribute :signed_by
    attribute :source
    attribute :last_mile_tracking_supported
    attribute :origin_country_iso3
    attribute :shipment_type
    attribute :shipment_weight
    attribute :shipment_weight_unit
    attribute :shipment_package_count
    attribute :shipment_pickup_date
    attribute :shipment_delivery_date
    attribute :smses
    attribute :unique_token

    attribute :checkpoints

    attribute :subscribed_smses
    attribute :subscribed_emails
    attribute :return_to_sender
    attribute :tracking_account_number
    attribute :tracking_origin_country
    attribute :tracking_destination_country
    attribute :tracking_key
    attribute :tracking_postal_code
    attribute :tracking_ship_date
    attribute :tracking_state
    attribute :order_promised_delivery_date
    attribute :delivery_type
    attribute :pickup_location
    attribute :pickup_note
    attribute :courier_tracking_link
    attribute :courier_redirect_link
    attribute :first_attempted_at

    TRACKING_INQUIRE_URLS = {
      aftership: 'https://gomicorp.aftership.com'
    }

    def self.all
      adapter.get_trackings.map { |data| new data }
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.find(tracking_number, carrier_code = nil)
      new adapter.get_tracking(tracking_number, carrier_code)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.create(tracking_number, carrier_code = nil)
      new adapter.create_tracking(tracking_number, carrier_code)
    end

    def delete
      klass = self.class
      klass.new klass.adapter.delete_tracking(id)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.delete(tracking_number, carrier_code = nil)
      new adapter.delete_tracking(tracking_number, carrier_code)
    end

    def update(**attributes)
      klass = self.class
      klass.new klass.adapter.update_tracking(id, **attributes)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.update(tracking_number, carrier_code = nil, **attributes)
      new adapter.update_tracking(tracking_number, carrier_code, **attributes)
    end

    def tracking_page_url
      [TRACKING_INQUIRE_URLS[:aftership], tracking_number].join('/')
    end

    def self.tracking_page_url(ship_info)
      [TRACKING_INQUIRE_URLS[:aftership], ship_info.tracking_number].join('/')
    end
  end
end
