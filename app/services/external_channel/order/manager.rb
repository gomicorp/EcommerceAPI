module ExternalChannel
  module Order
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        self.saver = ExternalChannel::Order::Saver.new
        self.validator = ExternalChannel::Order::Validator.new
        self.data_type = 'order'
      end
    end
  end
end
