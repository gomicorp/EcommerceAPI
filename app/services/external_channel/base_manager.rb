module ExternalChannel
  class BaseManager
    attr_reader :adapter, :saver, :validator, :data_type

    def initialize(channel_adapter)
      return false unless is_valid_adapter?(channel_adapter)
      @adapter = channel_adapter
    end

    def save_all
      list = adapter.get_list(data_type)
      saver.save_all(list) if validator.valid_all?(list)
    end

    protected
    # do not set saver directly!
    # Use this function when you want to set saver class
    def set_saver!(saver)
      if is_valid_saver? saver
        @saver = saver
        true
      else
        false
      end
    end

    # do not set validator directly!
    # Use this function when you want to set validator class
    def set_validator!(validator)
      if is_valid_validator? validator
        @validator = validator
        true
      else
        false
      end
    end

    # do not set data_type directly!
    # Use this function when you want to set validator class
    def set_data_type!(data_type)
      @data_type = data_type
    end

    private

    def is_valid_adapter?(channel_adapter)
      channel_adapter.is_a? ExternalChannel::BaseAdapter
    end

    def is_valid_saver?(saver)
      saver.is_a? ExternalChannel::BaseSaver
    end

    def is_valid_validator?(validator)
      validator.is_a? ExternalChannel::BaseValidator
    end
  end
end