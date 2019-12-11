module Gomisa
  module Companies
    class BaseController < ::Gomisa::BaseController
      before_action :set_company

      private

      def set_company
        @company = Company.find(params[:company_id])
      end
    end
  end
end
