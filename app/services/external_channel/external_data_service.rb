module ExternalChannel
  def self.select_service_by_data_type(data_type)
    case data_type
    when 'product'
      ExternalChannel::Product::ExternalProductService
    when 'order'
      ExternalChannel::Order::ExternalOrderService
    else
      nil
    end
  end

  class ExternalDataService
    attr_reader :adapter, :saver, :validator

    def initialize(channel_adapter)
      return false unless is_valid_adapter?(channel_adapter)
      @adapter = channel_adapter
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

    # do not set saver directly!
    # Use this function when you want to set saver class
    def set_saver!(saver)
      if is_valid_saver?
        @saver = saver
        true
      else
        false
      end
    end

    # do not set validator directly!
    # Use this function when you want ot set validator class
    def set_validator!(validator)
      if is_valid_validator?
        @validator = validator
        true
      else
        false
      end
    end

    private

    def is_valid_adapter?(channel_adapter)
      channel_adapter.instance_of? ExternalChannelAdapter
    end

    def is_valid_saver?(saver)
      saver.instance_of? ExternalChannelSaver
    end

    def is_valid_validator?(validator)
      validator.instance_of? ExternalChannelValidator
    end
  end
end