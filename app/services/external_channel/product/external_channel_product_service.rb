module ExternalChannel
  module Product
    class ExternalChannelProductService < ExternalChannelDataService


      def save
        products = adapter.products
        if validate(products)
          product_saver = ExternalProductSaver.new
          product_saver.save_batch(products)
        end
      end

      protected

      def validate(products)
        if validator.nil?
          @validator = ExternalProductsValidator.new
        end

        validator(products)
      end
    end
  end
end