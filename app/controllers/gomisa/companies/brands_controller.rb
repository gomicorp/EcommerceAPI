module Gomisa
  module Companies
    class BrandsController < BaseController
      before_action :set_brand, only: %i[show]

      def index
        @brands = @company.brands
      end

      def show
      end

      private

      def set_brand
        @brand = @company.brands.find(params[:id])
      end
    end
  end
end
