module ExternalChannel
  module Product
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        self.saver = ExternalChannel::Product::Saver.new
        self.validator = ExternalChannel::Product::Validator.new
        self.data_type = 'product'
      end
    end
  end
end
