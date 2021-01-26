module Partner
  class CompaniesController < BaseController
    before_action :authenticate_request!
    before_action :set_company, only: %i[show update destroy]

    def index
      companies = Company.all.includes(include_tables).where(query_param)
      @companies = decorator_class.decorate_collection(companies)

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

    protected

    def default_decorator_name
      'Companies::DefaultDecorator'
    end

    private

    def set_company
      company = Company.find(params[:id])
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
