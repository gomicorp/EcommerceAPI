module ExternalChannel
  module Order
    class ExternalOrderService < ExternalDataService
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannel::Order::ExternalChannelOrderSaver.new)
        set_validator!(ExternalChannel::Order::ExternalChannelOrderValidator.new)
      end
    end
  end
end