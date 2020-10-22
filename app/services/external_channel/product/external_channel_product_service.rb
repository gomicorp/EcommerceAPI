module ExternalChannel
  module Product
    class ExternalChannelProductService < ExternalChannelDataService
      def save
        products = adapter.products
        if validate_all(products)
          # TODO: country_code를 외부로 부터 입력 받아야 함.
          product_saver = ExternalChannelProductSaver.new
          product_saver.save_batch(products)
        end
      end

      protected

      def validate_all(products)
        if validator.nil?
          @validator = ExternalProductsValidator.new
        end

        validator(products)
      end
    end
  end
end