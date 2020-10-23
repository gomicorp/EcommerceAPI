module ExternalChannel
  def self.get_behavior_by_data_type(data_type)
    case data_type
    when "product"
      ExternalChannel::Product::ExternalChannelProductCommander
    when "order"
      ExternalChannel::Order::ExternalChannelOrderCommander
    end
  end

  class ExternalChannelDataCommander
    attr_reader :saver, :validator

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

    def is_valid_saver?(saver)
      saver.instance_of? ExternalChannelSaver
    end

    def is_valid_validator?(validator)
      validator.instance_of? ExternalChannelValidator
    end
  end
end