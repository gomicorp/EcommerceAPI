module Gomisa
  module Brands
    class BaseController < ::Gomisa::BaseController
      before_action :set_brand

      private

      def set_brand
        @brand = Brand.find(params[:brand_id])
      end
    end
  end
end
