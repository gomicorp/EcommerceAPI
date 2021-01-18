module Api
  module V1
    class ProductItemsController < BaseController
      before_action :set_product_item, only: %i[show update destroy]

      # GET /product_items
      # GET /product_items.json
      def index
        @product_items = ProductItem.all
      end

      # GET /product_items/1
      # GET /product_items/1.json
      def show
      end

      # POST /product_items
      # POST /product_items.json
      def create
        @product_item = ProductItem.new(product_item_params)

        if @product_item.save
          render :show, status: :created, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /product_items/1
      # PATCH/PUT /product_items/1.json
      def update
        if @product_item.update(product_item_params)
          render :show, status: :ok, location: @product_item
        else
          render json: @product_item.errors, status: :unprocessable_entity
        end
      end

      # DELETE /product_items/1
      # DELETE /product_items/1.json
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
