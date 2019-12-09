module Partner
  class BrandsController < BaseController
    before_action :set_brand, only: %i[show edit update destroy]

    # GET /partner/brands
    # GET /partner/brands.json
    def index
      @brands = Brand.all
    end

    # GET /partner/brands/1.json
    def show
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

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      country = Country.find(params[:brand][:country_id])
      name = params[:brand][:name]
      params[:brand][:name] = name.merge(country.locale => name['en'])

      params.require(:brand).permit(:company_id, :country_id, :logo, name: {})
    end
  end
end
