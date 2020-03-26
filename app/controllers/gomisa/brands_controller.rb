module Gomisa
  class BrandsController < BaseController
    before_action :set_brand, only: [:show, :edit, :update, :destroy]
    before_action do
      ActiveStorage::Current.host = request.base_url
    end
    # GET /gomisa/brands
    # GET /gomisa/brands.json
    def index
      @brands = Brand.all
    end

    # GET /gomisa/brands/1
    # GET /gomisa/brands/1.json
    def show
    end

    def create
      @brand = Brand.new(brand_params)

      if @brand.save
        render json: @brand, status: :created
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end

    def update
      @brand.attributes = brand_params

      if @brand.save
        render json: @brand, status: :reset_content
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end

    def destroy
      # delete will only delete current object record from db but not its associated children records from db.
      # destroy will delete current object record from db and also its associated children record from db.
      begin
        @brand.delete
        render json: {}, status: :no_content
      rescue ActiveRecord::InvalidForeignKey => e
        render json: { error: e.to_s }, status: :failed_dependency
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:company_id, :eng_name, :pixel_id, :logo, name: {})
    end
  end
end

