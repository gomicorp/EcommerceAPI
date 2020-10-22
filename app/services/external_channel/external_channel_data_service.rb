module ExternalChannel
  class ExternalChannelDataService
    attr_reader :adapter, :saver, :validator

    def initialize(channel_adapter)
      return false unless is_valid_adapter?(channel_adapter)
      @adapter = channel_adapter
    end

    def save
      raise NotImplementedError.new('External Channel Data Service Must Have Save Function')
    end


    protected

    def validate
      raise NotImplementedError.new('External Channel Data Service Must Have validate Function')
    end

    def is_valid_adapter?(channel_adapter)
      channel_adapter.instance_of? ExternalChannelAdapter
    end
  end
end