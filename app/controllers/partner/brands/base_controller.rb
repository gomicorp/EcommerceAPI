module Partner
  module Brands
    class BaseController < ::Partner::BaseController
      before_action :authenticate_request!
      before_action :set_brands
      before_action :set_brand

      private

      def set_brands
        @brands = current_user.brands.includes(include_tables)
      end

      def set_brand
        @brand = @brands.find(params[:brand_id])
      end

      def include_tables
        [:company, :country]
      end
    end
  end
end
