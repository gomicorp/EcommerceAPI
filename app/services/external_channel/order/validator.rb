module ExternalChannel
  module Order
    class Validator < BaseValidator
      def initialize
        order_keys = %i[id order_number receiver_name paid_at order_status pay_method channel ordered_at billing_amount ship_fee variant_ids cancelled_status shipping_status tracking_company_code confirmed_status source_name delivered_at]
        super(order_keys)
      end

      def valid_all?(orders)
        true
        
        # orders.all? do |order|
        #   valid? order
        # end
      end

      def valid?(order)
        validate_presence_of(order, %i[paid_at cancelled_status shipping_status tracking_company_code confirmed_status source_name delivered_at])
        only_allowed?(order)
      end
    end
  end
end
