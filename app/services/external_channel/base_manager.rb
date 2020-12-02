module ExternalChannel
  class BaseManager
    attr_accessor :data_type
    attr_reader :adapter, :saver, :validator

    def initialize(channel_adapter)
      return unless valid_adapter?(channel_adapter)

      @adapter = channel_adapter
    end

    def save_all(query_hash = {})
      list = adapter.get_list(data_type, query_hash)
      saver.save_all(list) if validator.valid_all?(list)
    end

    protected

    # do not set saver directly!
    # Use this function when you want to set saver class
    def saver=(saver)
      if valid_saver? saver
        @saver = saver
        true
      else
        false
      end
    end

    # do not set validator directly!
    # Use this function when you want to set validator class
    def validator=(validator)
      return false unless valid_validator? validator

      @validator = validator
      true
    end

    private

    def valid_adapter?(channel_adapter)
      channel_adapter.is_a? BaseAdapter
    end

    def valid_saver?(saver)
      saver.is_a? BaseSaver
    end

    def valid_validator?(validator)
      validator.is_a? BaseValidator
    end
  end
end
