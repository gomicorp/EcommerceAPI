module ExternalChannel
  module Product
    class Validator < BaseValidator
      attr_reader :variant_validator

      def initialize
        product_keys = %i[id title channel_name brand_name variants]
        super(product_keys)

        @variant_validator = ExternalChannelVariantValidator.new
      end

      def valid_all?(products)
        products.all? { |product| valid? product }
      end

      def valid?(product)
        validate_presence_of(product)
        only_allowed?(product)
        variant_validator.valid_all?(product[:variants])
      end

      class ExternalChannelVariantValidator < BaseValidator
        def initialize
          variants_keys = %i[id price name]
          super(variants_keys)
        end

        def valid_all?(variants)
          variants.all? do |variant|
            valid? variant
          end
        end

        def valid?(variant)
          validate_presence_of(variant)
          only_allowed?(variant)
        end
      end
    end
  end
end
