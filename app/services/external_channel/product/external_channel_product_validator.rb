module ExternalChannel
  module Product
    def self.validate(products)
      product_validator = ExternalProductValidator.new()

      products.all? do |product|
        product_validator.set_data(product)
        return if product_validator.valid?
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
  end
end