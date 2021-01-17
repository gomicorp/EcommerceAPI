module Api
  module V1
    class ProductCollectionsController < BaseController
      before_action :set_product_collection, only: %i[show update destroy]

      # GET /product_collections
      # GET /product_collections.json
      def index
        @product_collections = ProductCollection.all
      end

      # GET /product_collections/1
      # GET /product_collections/1.json
      def show
      end

      # POST /product_collections
      # POST /product_collections.json
      def create
        @product_collection = ProductCollection.new(product_collection_params)

        if @product_collection.save
          render :show, status: :created, location: @product_collection
        else
          render json: @product_collection.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /product_collections/1
      # PATCH/PUT /product_collections/1.json
      def update
        if @product_collection.update(product_collection_params)
          render :show, status: :ok, location: @product_collection
        else
          render json: @product_collection.errors, status: :unprocessable_entity
        end
      end

      # DELETE /product_collections/1
      # DELETE /product_collections/1.json
      def destroy
        @product_collection.destroy
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_product_collection
        @product_collection = ProductCollection.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_collection_params
        params.fetch(:product_collection, {})
      end
    end
  end
end
