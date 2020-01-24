module Haravan
  class Fulfillment < Api::Record
    self.schema = %i[
      id
      order_id
      created_at
      updated_at

      tracking_number
      tracking_url
      _line_items

      cod_amount
      carrier_status_name
      carrier_cod_status_name
      carrier_status_code
      carrier_cod_status_code

      ready_to_pick_date
      picking_date
      delivering_date
      delivered_date
      return_date
      not_meet_customer_date
      waiting_for_return_date
      cod_paid_date
      cod_receipt_date
      cod_pending_date
      cod_not_receipt_date
      cancel_date
    ]

    has_many :line_items, class_name: 'Haravan::LineItem', data_from: '_line_items'

    def delivered?
      carrier_status_code == 'delivered'
    end
  end
end

# => Dropped Schema
#
# receipt
# status
# tracking_company
# tracking_company_code
#
# notify_customer
# province
# province_code
# district
# district_code
# ward
# ward_code
#
# location_id
# shipping_package
# note
# carrier_service_package
# carrier_service_package_name
# is_new_service_package
# coupon_code
#
# is_view_before
# country
# country_code
# zip_code
# city
# real_shipping_fee
# shipping_notes
# total_weight
# package_length
# package_width
# package_height
# boxme_servicecode
# transport_type
# address
# sender_phone
# sender_name
# carrier_service_code
# from_longtitude
# from_latitude
# to_longtitude
# to_latitude
# sort_code
# is_drop_off
# is_insurance
# insurance_price
# is_open_box
# request_id
# carrier_options
# note_attributes
