module ExternalChannel
  class ExternalChannelService
    attr_reader :adapter, :commander, :data_type

    def initialize(channel_adapter, commander, data_type)
      return false unless is_valid_adapter?(channel_adapter)
      @adapter = channel_adapter
      @data_type = data_type
      @commander = commander
    end

    def save_all
      begin
        # TODO: Adatpter에서 파라미터에 데이터타입으로 해당 데이터를 가져올 수 있도록 해야
        # data = adapter.getList(data_type)
        saver.save_all data if validator.valid_all? data
      rescue Error => e
        ap e
      end
    end

    protected

    def is_valid_adapter?(channel_adapter)
      channel_adapter.instance_of? ExternalChannelAdapter
    end
  end
end