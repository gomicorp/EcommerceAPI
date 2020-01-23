module Haravan
  class Order < Api::Record
    self.table_name = 'orders'
    self.root_key = 'orders'
    self.schema = %i[
      _billing_address

      cancel_reason
      cancelled_at

      closed_at
      created_at
      currency

      email
      financial_status
      _fulfillments
      fulfillment_status

      id

      source

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
    ]

    has_many :fulfillments, class_name: 'Haravan::Fulfillment', data_from: '_fulfillments'

    def inspect
      "#<#{self.class.name} id: #{id}, name: \"#{name}\", created_at: \"#{created_at.strftime('%F %X')}\", updated_at: \"#{updated_at.strftime('%F %X')}\">"
    end

    def delivered?
      fulfillments.filter(&:delivered?).any?
    end

    def recent_fulfillment
      fulfillments.first
    end

    def items
      recent_fulfillment&.line_items
    end

    def identity_object
      { id: id, name: name }
    end
  end
end

=begin

=> Dropped Schema

browser_ip
buyer_accepts_marketing

cart_token
checkout_token
_client_details

_customer
_discount_codes

tags
gateway
gateway_code

landing_site
landing_site_ref

_line_items

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

=end
