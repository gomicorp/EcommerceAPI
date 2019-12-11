module Gomisa
  class BrandsController < BaseController
    before_action :set_brand, only: [:show, :edit, :update, :destroy]

    # GET /gomisa/brands
    # GET /gomisa/brands.json
    def index
      @brands = Brand.all
    end

    # GET /gomisa/brands/1
    # GET /gomisa/brands/1.json
    def show
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.fetch(:brand, {})
    end
  end
end
