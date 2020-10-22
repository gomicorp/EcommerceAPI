module ExternalChannel
  class ExternalDataValidator
    include ActiveModel::Validations

    attr_accessor :validator, :data

    def validate(data)
      raise NotImplementedError.new('External Channel Validator Must Have Validate Function')
    end
  end
end