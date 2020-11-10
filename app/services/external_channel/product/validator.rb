module ExternalChannel
  module Product
    class Validator < BaseValidator

      attr_reader :variant_validator

      def initialize
        @keys = [:id, :title, :channel_name, :brand_name, :variants]
        @variant_validator = ExternalChannelVariantValidator.new
      end

      def valid_all?(products)
        products.all? {|product| valid? product }
      end

      def valid?(product)
        validate_presence_of(product)
        has_only_allowed(product)
        variant_validator.valid_all?(product[:variants])
      end

      private

      class ExternalChannelVariantValidator < BaseValidator
        def initialize
          @keys = [:id, :price, :name]
        end

        def valid_all?(variants)
          variants.all? do |variant|
            valid? variant
          end
        end

        def valid?(variant)
          validate_presence_of(variant)
          has_only_allowed(variant)
        end
      end
    end
  end
end