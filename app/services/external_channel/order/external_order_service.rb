module ExternalChannel
  module Order
    class ExternalOrderService < ExternalDataService
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannelOrderSaver.new)
        set_validator!(ExternalChannelOrderValidator.new)
      end
    end
  end
end