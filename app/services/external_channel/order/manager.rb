module ExternalChannel
  module Order
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        self.saver = Saver.new
        self.validator = Validator.new
        self.data_type = 'order'
      end
    end
  end
end
