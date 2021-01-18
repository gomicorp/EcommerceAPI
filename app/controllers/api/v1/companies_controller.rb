module Api
  module V1
    class CompaniesController < BaseController
      before_action :set_company, only: %i[show update destroy]

      # GET /companies
      def index
        @companies = Company.all
      end

      # GET /companies/1
      def show
      end

      # POST /companies
      def create
        @company = Company.new(company_params)

        if @company.save
          render :show, status: :created, location: [:api, :v1, @company]
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /companies/1
      def update
        if @company.update(company_params)
          render :show, status: :ok, location: [:api, :v1, @company]
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      # DELETE /companies/1
      def destroy
        @company.destroy
      end


      private

      # Use callbacks to share common setup or constraints between actions.
      def set_company
        @company = Company.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def company_params
        params.fetch(:company, {}).permit(:name)
      end
    end
  end
end
