module Partner
  class CompaniesController < BaseController
    before_action :authenticate_request!
    before_action :set_company, only: %i[show update destroy]

    def index
      user_companies = @current_user.companies.includes(include_tables)
      @companies = decorator.decorate_collection(user_companies.where(query_param))

      render json: @companies, template: 'partner/companies/index'
    end

    def show
      render json: @company
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

    def update
      @service = CompanyUpdateService.new(@company, params)

      if @service.save
        render :show, status: :ok
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = decorator.decorate(@current_user.companies.find(params[:id]))
    end

    def include_tables
      [:brands, ownership: :manager, memberships: :manager]
    end

    def query_param
      params.permit(*Company.attribute_names, id: [])
    end

    def default_decorator
      { deco_type: 'Companies::DefaultDecorator' }
    end
  end
end
