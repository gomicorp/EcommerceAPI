module Haravan
  class LineItem < Api::Record
    self.schema = %i[
      fulfillment_status

      id
      price
      product_id
      quantity

      sku
      title
      variant_id
      variant_title
      vendor
      name
    ]

    attr_accessor :order
  end
end

=begin

=> Dropped Schema

fulfillable_quantity
fulfillment_service

grams

requires_shipping

variant_inventory_management
properties
product_exists

=end
