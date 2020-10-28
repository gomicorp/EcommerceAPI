module ExternalChannel
  module Order
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannel::Order::Saver.new)
        set_validator!(ExternalChannel::Order::Validator.new)
        set_data_type!('order')
      end
    end
  end
end