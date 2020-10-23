module ExternalChannel
  module Order
    class ExternalChannelOrderValidator < ExternalChannel::ExternalChannelValidator

      def initialize
        @keys = [:id, :order_number, :paid_at, :order_status, :pay_method, :channel, :ordered_at, :billing_amount, :ship_fee, :variant_ids, :canceled_status, :shipping_status]
      end

      def valid_all?(orders)
        orders.all? do |order|
          valid? order
        end
      end

      def valid?(order)
        validate_presence_of(order)
        has_only_allowed(order)
      end
    end
  end
end