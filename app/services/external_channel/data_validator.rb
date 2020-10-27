module ExternalChannel
  class DataValidator

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

    def validate_presence_of(data)
      keys.all? { |key| !data[key].blank? }
    end

  end
end