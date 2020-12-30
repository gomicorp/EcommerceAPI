module Partner
  class BrandsController < BaseController
    before_action :authenticate_request!
    before_action :set_brand, only: %i[show edit update destroy]

    # GET /partner/brands
    # GET /partner/brands.json
    def index
      my_brands = @current_user.brands.includes(include_tables).where(query_param)
      @brands = decorator_class.decorate_collection(my_brands)

      render json: @brands
    end

    # GET /partner/brands/1.json
    def show
      render json: @brand
    end

    # POST /partner/brands.json
    def create
      @brand = Brand.new(brand_params)
      # @brand.logo = params[:logo].permit! if params[:logo].present?

      if @brand.save
        render :show, status: :created
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /partner/brands/1.json
    def update
      @brand.assign_attributes(brand_params)
      # @brand.logo = params[:logo].permit! if params[:logo].present?

      if @brand.save
        render :show, status: :ok
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end

    # DELETE /partner/brands/1.json
    def destroy
      @brand.destroy
      head :no_content
    end

    protected

    def default_decorator_name
      'Brands::DefaultDecorator'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      my_brand = @current_user.brands.find(params[:id])
      @brand = decorator_class.decorate(my_brand)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      country = Country.find(params[:brand][:country_id])
      name = params[:brand][:name]
      params[:brand][:name] = name.merge(country.locale => name['en'])

      params.require(:brand).permit(:company_id, :country_id, :logo, name: {})
    end

    def include_tables
      [:company, :country]
    end

    def query_param
      params.permit(*Brand.attribute_names, id: [])
    end
  end
end
