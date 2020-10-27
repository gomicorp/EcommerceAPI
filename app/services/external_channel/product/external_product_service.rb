module ExternalChannel
  module Product
    class ExternalProductService < ExternalDataService
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannel::Product::ExternalChannelProductSaver.new)
        set_validator!(ExternalChannel::Product::ExternalChannelProductValidator.new)
      end
    end
  end
end