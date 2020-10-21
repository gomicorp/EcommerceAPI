module ExternalChannel
  class ExternalDataValidator
    include ActiveModel::Validations

    attr_reader :data

    def set_data(data = {})
      @data = data
    end

    protected

    def read_attr_from_data(key)
      data[key]
    end
  end
end