module Partner
  module Brands
    class ProductItemsController < BaseController
      before_action :set_product_item, only: %i[show update destroy]

      # GET /partner/brands/1/product_items
      # GET /partner/brands/1/product_items.json
      def index
        @product_items = @brand.items.all
      end

      # GET /partner/brands/1/product_items/1
      # GET /partner/brands/1/product_items/1.json
      def show
      end

      # POST /partner/brands/1/product_items
      # POST /partner/brands/1/product_items.json
      def create
        @product_item = @brand.items.new(product_item_params)

        if @product_item.save
          render :show, status: :created, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /partner/brands/1/product_items/1
      # PATCH/PUT /partner/brands/1/product_items/1.json
      def update
        if @product_item.update(product_item_params)
          render :show, status: :ok, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # DELETE /partner/brands/1/product_items/1
      # DELETE /partner/brands/1/product_items/1.json
      def destroy
        @product_item.destroy
      end


      private

      # Use callbacks to share common setup or constraints between actions.
      def set_product_item
        @product_item = @brand.items.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_item_params
        params.fetch(:product_item, {})
      end
    end
  end
end
