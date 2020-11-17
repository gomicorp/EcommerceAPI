module ExternalChannel
  class BaseValidator
    attr_reader :keys

    def initialize(keys)
      @keys = keys || []
    end

    def valid_all?(_data)
      raise NotImplementedError, 'External Channel Validator Service Must Have Valid? Function'
    end

    def valid?(_data)
      raise NotImplementedError, 'External Channel Validator Service Must Have Valid? Function'
    end

    protected

    def only_allowed?(data)
      data.keys.sort == keys.sort
    end

    def validate_presence_of(data, exception = [])
      keys.all? do |key|
        next if exception.include? key

        !data[key].blank?
      end
    end
  end
end
