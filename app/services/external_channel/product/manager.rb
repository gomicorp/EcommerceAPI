module ExternalChannel
  module Product
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        self.saver = Saver.new
        self.validator = Validator.new
        self.data_type = 'product'
      end
    end
  end
end
