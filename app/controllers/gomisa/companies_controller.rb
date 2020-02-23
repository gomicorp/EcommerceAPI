module Gomisa
  class CompaniesController < BaseController
    before_action :set_company, only: [:show, :edit, :update, :destroy]
    # GET /gomisa/companies
    # GET /gomisa/companies.json
    def index
      @companies = Company.all
    end

    # GET /gomisa/companies/1
    # GET /gomisa/companies/1.json
    def show
    end

    # POST /gomisa/companies.json
    def create
      @company = Company.new(company_params)

      if @company.save
        render json: @company, status: :created
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    end

    def update
      @company.attributes = company_params

      if @company.save
        render json: @company, status: :ok
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    end

    def destroy
      # delete will only delete current object record from db but not its associated children records from db.
      # destroy will delete current object record from db and also its associated children record from db.
      begin
        @company.delete
        render json: {}, status: :no_content
      rescue ActiveRecord::InvalidForeignKey => e
        render json: { error: e.to_s }, status: :failed_dependency
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name)
    end
  end
end
