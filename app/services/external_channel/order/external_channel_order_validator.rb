module ExternalChannel
  module Order
    class ExternalChannelOrderValidator < ExternalChannel::ExternalChannelValidator

      def initialize
        @keys = [:id, :order_number, :paid_at, :order_status, :pay_method, :channel, :ordered_at, :billing_amount, :ship_fee, :variant_ids, :cancelled_status, :shipping_status, ]
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

      protected

      @override
      def has_only_allowed(data)
        data[:paid_at] = 'empty' if data[:paid_at].nil?
        data[:shipping_status] = 'not work' if data[:shipping_status].nil?
        super(data)
      end
    end
  end
end