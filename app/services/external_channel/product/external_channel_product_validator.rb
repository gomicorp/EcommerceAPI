module ExternalChannel
  module Product
    class ExternalProductsValidator < ExternalChannel::ExternalDataValidator
      def validate(products)
        variants_validator = ExternalVariantsValidator.new
        product_validator = ExternalProductValidator.new(variants_validator)

        products.all? do |product|
          product_validator.set_data(product)
          return product_validator.valid?
        end
      end
    end

    class ExternalProductValidator < ExternalChannel::ExternalDataValidator
      validates_presence_of :id, :title, :channel_name, :brand_name, :variants
      validate :validate_variants

      attr_reader :variants_validator

      def initialize(variants_validator)
        return if variants_validator.instance_of? ExternalChannel::ExternalDataValidator
        @variants_validator = variants_validator
      end

      def validate_variants
        variants = data[:variants]

        variants.all? do |variant|
          variants_validator.set_data(variant)
          return if variants_validator.valid?
        end
      end
    end

    class ExternalVariantsValidator < ExternalChannel::ExternalDataValidator
      validates_presence_of :id, :price, :name
    end
  end
end