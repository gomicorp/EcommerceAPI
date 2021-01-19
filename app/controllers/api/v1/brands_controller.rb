module Api
  module V1
    class BrandsController < BaseController
      before_action :set_brand, only: %i[show update destroy]

      # GET /brands
      # GET /brands.json
      def index
        @brands = Brand.all
      end

      # GET /brands/1
      # GET /brands/1.json
      def show
      end

      # POST /brands
      # POST /brands.json
      def create
        @brand = Brand.new(brand_params)

        if @brand.save
          render :show, status: :created, location: @brand
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /brands/1
      # PATCH/PUT /brands/1.json
      def update
        if @brand.update(brand_params)
          render :show, status: :ok, location: @brand
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
      end

      # DELETE /brands/1
      # DELETE /brands/1.json
      def destroy
        @brand.destroy
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_brand
        @brand = Brand.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def brand_params
        params.fetch(:brand, {})
      end
    end
  end
end
