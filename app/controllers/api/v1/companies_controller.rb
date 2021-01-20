module Api
  module V1
    class CompaniesController < BaseController
      before_action :set_company, only: %i[show update destroy]

      # GET /companies
      def index
        @companies = decorator_class.decorate_collection(Company.all)

        render json: @companies
      end

      # GET /companies/1
      def show
        render json: @company
      end

      # POST /companies
      def create
        @company = Company.new(company_params)

        if @company.save
          render json: @company
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /companies/1
      def update
        if @company.update(company_params)
          render json: @company
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      # DELETE /companies/1
      def destroy
        @company.destroy
      end

      protected

      def default_decorator_name
        'Companies::DefaultDecorator'
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_company
        @company = decorator_class.decorate(Company.find(params[:id]))
      end

      # Only allow a list of trusted parameters through.
      def company_params
        params.fetch(:company, {}).permit(:name)
      end
    end
  end
end
