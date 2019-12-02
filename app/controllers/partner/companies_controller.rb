module Partner
  class CompaniesController < BaseController
    # before_action :authenticate_request!
    before_action :set_company, only: %i[show]

    def index
      @companies = Company.includes(:brands, ownership: :manager, memberships: :manager).all
    end

    def show
    end

    def create
      @service = CompanyCreateService.new(params)
      @company = @service.company

      if @service.save
        render :show, status: :created
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = Company.find(params[:id])
    end
  end
end
