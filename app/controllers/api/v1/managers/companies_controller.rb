module Api
  module V1
    module Managers
      class CompaniesController < BaseController
        before_action :authenticate_request!
        before_action :set_manager
        before_action :set_company, only: %i[show]

        # GET: /api/v1/managers/:manager_id/companies
        def index
          @companies = decorator_class.decorate_collection(@manager.companies)

          render json: @companies
        end

        # GET: /api/v1/managers/:manager_id/companies/:id
        def show
          render json: @company
        end

        protected

        def default_decorator_name
          'Companies::DefaultDecorator'
        end

        private

        def set_manager
          @manager = Manager.find(params[:manager_id])
        end

        def set_company
          company = @manager.companies.find(params[:id])
          @company = decorator_class.decorate(company)
        end
      end
    end
  end
end
