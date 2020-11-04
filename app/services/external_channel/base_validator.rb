module ExternalChannel
  class BaseValidator

    attr_reader :keys

    def initialize
      @keys = []
    end

    def valid_all?(data)
      raise NotImplementedError.new('External Channel Validator Service Must Have Valid? Function')
    end

    def valid?(data)
      raise NotImplementedError.new('External Channel Validator Service Must Have Valid? Function')
    end

    protected

    def has_only_allowed(data)
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