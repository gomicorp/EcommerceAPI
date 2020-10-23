module ExternalChannel
  module Product
    class ExternalChannelProductCommander < ExternalChannelDataCommander
      def initialize
        set_saver!(ExternalChannelProductSaver.new)
        set_validator!(ExternalChannelProductValidator.new)
      end
    end
  end
end