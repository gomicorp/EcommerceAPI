module Haravan
  class Order < Api::Record
    self.table_name = 'orders'
    self.root_key = 'orders'
    self.schema = %i[
      _billing_address
      browser_ip
      buyer_accepts_marketing
      cancel_reason
      cancelled_at
      cart_token
      checkout_token
      _client_details
      closed_at
      created_at
      currency
      _customer
      _discount_codes
      email
      financial_status
      _fulfillments
      fulfillment_status
      tags
      gateway
      gateway_code
      id
      landing_site
      landing_site_ref
      source
      _line_items
      name
      note
      number
      order_number
      processing_method
      referring_site
      _refunds
      _shipping_address
      _shipping_lines
      source_name
      subtotal_price
      tax_lines
      taxes_included
      token
      total_discounts
      total_line_items_price
      total_price
      total_tax
      total_weight
      updated_at
      _transactions
      _note_attributes
      confirmed_at
      closed_status
      cancelled_status
      confirmed_status
      user_id
      device_id
      location_id
      ref_order_id
      ref_order_number
      utm_source
      utm_medium
      utm_campaign
      utm_term
      utm_content
      redeem_model
    ]

    def inspect
      "#<#{self.class.name} id: #{id}, name: \"#{name}\", created_at: \"#{created_at.strftime('%F %X')}\", updated_at: \"#{updated_at.strftime('%F %X')}\">"
    end

    def shipped?
      _fulfillments.filter { |ff|
        if ff[:carrier_status_code] == 'delivered' && !ff[:order_id].in?([1099662053,1099661633,1099660880,1099656563,1099654262,1099649465,1099644881,1099640165,1099636688,1099635866,1099634855,1099632098,1099625906,1099625477,1099623446,1099621100,1099616951,1099554596,1099549607,1099540865,1099535777,1099535507,1099532492,1099531910,1099528256,1099526390,1099525679,1099487987,1099480877,1099479545,1099477703,1099476992,1099475894,1099475222,1099470740,1099469591,1099469318,1099468124,1099466846,1099452425,1099451837,1099450583,1099446923,1099445489,1099442306,1099436300,1099432157,1099422707,1099409456,1099403135,1099402211,1099398332,1099397639,1099391600,1099383185,1099378766,1099378283,1099366112,1099365368,1099360601,1099358645,1099354565,1099332395,1099330610,1099323083,1099251857,1099246619,1099240475,1099224647,1099220780,1099218767,1099218206,1099210355,1099209668,1099200251,1099195811,1099173281,1099168364,1099167356,1099163900,1099162829,1099152899,1099136819,1099127618,1099126970,1099111652,1099099010,1099095581,1099094174,1099093766,1099089110,1099085621,1099084907,1099024952,1099024751,1099014623,1099014248,1099012610,1099002929,1099002398,1099001048,1098994886,1098994376,1098987812,1098987281,1098987146,1098983255,1098983117,1098981428,1098978212,1098977534,1098975272,1098972842,1098961082,1098959333,1098958031,1098957806,1098957344,1098947309,1098944849,1098942626,1098940364,1098938999,1098937832,1098930467,1098929345,1098927668,1098923936,1098923810,1098920237,1098903419,1098898562,1098893372,1098890912,1098888455,1098887678,1098887243,1098885794,1098882647,1098882377,1098877919,1098876173,1098874520,1098869552,1098859850,1098858923,1098853841])
          # p ff[:order_id]
          # p ff[:carrier_status_code]
          # ap ff
        end
        # puts ""
        # ff[:status] == 'success' &&
            ff[:carrier_status_code] == 'delivered'
      }.first.present?
    end

    def items
      return nil unless _fulfillments.first.present?

      _fulfillments.first[:line_items]
    end
  end
end
