module Partner
  module Managers
    class CompaniesController < BaseController
      before_action :authenticate_request!
      before_action :set_manager
      before_action :set_company, only: %i[show]

      # GET /partner/managers/:manager_id/companies
      def index
        companies = @manager.companies.includes(include_tables).where(query_param)
        @companies = decorator_class.decorate_collection(companies)

        render json: @companies
      end

      # GET /partner/managers/:manager_id/companies/:id
      def show
        render json: @company
      end

      protected

      def default_decorator_name
        '::Companies::DefaultDecorator'
      end

      def set_manager
        @manager = Manager.find(params[:manager_id])
      end

      def set_company
        company = @manager.companies.find(params[:id])
        @company = decorator_class.decorate(company)
      end

      def include_tables
        [:brands, ownership: :manager, memberships: :manager]
      end

      def query_param
        params.permit(*Company.attribute_names, id: [])
      end
    end
  end
end
