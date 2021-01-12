module ExternalChannel
  module Order
    class Validator < BaseValidator
      def initialize
        order_keys = %i[id order_number customer_name paid_at order_status pay_method channel ordered_at billing_amount ship_fee variant_ids cancelled_status shipping_status row_data]
        super(order_keys)
      end

      def valid_all?(orders)
        orders.all? do |order|
          valid? order
        end
      end

      def valid?(order)
        validate_presence_of(order, %i[paid_at cancelled_status shipping_status])
        only_allowed?(order)
      end
    end
  end
end
