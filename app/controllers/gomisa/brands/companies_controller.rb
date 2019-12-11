module Gomisa
  module Brands
    class CompaniesController < BaseController
      before_action :set_company, only: %i[show]

      def show
      end

      private

      def set_company
        @company = @brand.company
      end
    end
  end
end
