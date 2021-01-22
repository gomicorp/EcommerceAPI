module Api
  module V1
    class ProductItemsController < BaseController
      before_action :authenticate_request!
      before_action :set_product_item, only: %i[show update destroy]

      # GET /api/v1/product_items
      # GET /api/v1/product_items.json
      def index
        @product_items = ProductItem.all
      end

      # GET /api/v1/product_items/1
      # GET /api/v1/product_items/1.json
      def show
      end

      # POST /api/v1/product_items
      # POST /api/v1/product_items.json
      def create
        @product_item = ProductItem.new(product_item_params)

        if @product_item.save
          render :show, status: :created, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/product_items/1
      # PATCH/PUT /api/v1/product_items/1.json
      def update
        if @product_item.update(product_item_params)
          render :show, status: :ok, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/product_items/1
      # DELETE /api/v1/product_items/1.json
      def destroy
        @product_item.destroy
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_product_item
        @product_item = ProductItem.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_item_params
        params.fetch(:product_item, {})
      end
    end
  end
end
