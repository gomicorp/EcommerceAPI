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

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.fetch(:company, {})
    end
  end
end
