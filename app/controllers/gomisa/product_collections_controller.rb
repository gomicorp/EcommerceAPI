module Gomisa
  class ProductCollectionsController < BaseController
    before_action :set_product_collection, only: [:show, :edit, :update, :destroy]

    # GET /product_collections
    # GET /product_collections.json
    def index
      @product_collections = ProductCollection.all
    end

    # GET /product_collections/1
    # GET /product_collections/1.json
    def show
    end

    # GET /product_collections/new
    def new
      @product_collection = ProductCollection.new
    end

    # GET /product_collections/1/edit
    def edit
    end

    # POST /product_collections
    # POST /product_collections.json
    def create
      @product_collection = ProductCollection.new(product_collection_params)

      if @product_collection.save
        render :show, status: :created
      else
        render json: @product_collection.errors, status: :bad_request
      end
    end

    # PATCH/PUT /product_collections/1
    # PATCH/PUT /product_collections/1.json
    def update
      if @product_collection.update(product_collection_params)
        render :show , status: :reset_content
      else
        render json: @product_collection.errors, status: :bad_request
      end
    end

    # DELETE /product_collections/1
    # DELETE /product_collections/1.json
    def destroy
      begin
        @product_collection.delete
        render json: {}, status: :no_content
      rescue ActiveRecord::InvalidForeignKey => e
        render json: { error: e.to_s }, status: :failed_dependency
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_product_collection
      @product_collection = ProductCollection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_collection_params
      params.require(:product_collection).permit(:name)
    end
  end
end
