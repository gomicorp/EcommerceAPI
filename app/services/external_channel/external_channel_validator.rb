module ExternalChannel
  def self.validate_products(products)
    product_validator = ExternalProductValidator.new()

    products.all? do |product|
      product_validator.set_data(product)
      return if product_validator.valid?
    end
  end

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

  class ExternalProductValidator < ExternalDataValidator
    validates_presence_of :id, :title, :channel_name, :brand_name, :variants
    validate :validate_variants

    attr_reader :variants_validator

    def initialize
      @variants_validator = ExternalVariantsValidator.new()
    end

    def validate_variants
      variants = data[:variants]

      variants.all? do |variant|
        variants_validator.set_data(variant)
        return if variants_validator.valid?
      end
    end


  end

  class ExternalVariantsValidator < ExternalDataValidator
    validates_presence_of :id, :price, :name
  end

  class ExternalOrderValidator < ExternalDataValidator

  end
end