module ExternalChannel
  module Product
    class Manager < BaseManager
      def initialize(channel_adapter)
        super(channel_adapter)
        set_saver!(ExternalChannel::Product::Saver.new)
        set_validator!(ExternalChannel::Product::Validator.new)
        set_data_type!('product')
      end
    end
  end
end