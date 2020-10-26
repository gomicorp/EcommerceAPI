module ExternalChannel
  module Product
    class ExternalProductService < ExternalDataService
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannelProductSaver.new)
        set_validator!(ExternalChannelProductValidator.new)
      end
    end
  end
end