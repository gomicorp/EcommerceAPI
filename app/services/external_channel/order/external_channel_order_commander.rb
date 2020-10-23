module ExternalChannel
  module Order
    class ExternalChannelOrderCommander < ExternalChannelDataCommander
      def initialize
        set_saver!(ExternalChannelOrderSaver.new)
        set_validator!(ExternalChannelOrderValidator.new)
      end
    end
  end
end