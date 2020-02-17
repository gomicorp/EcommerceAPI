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

      respond_to do |format|
        if @product_collection.save
          format.html { redirect_to office_product_collection_path(@product_collection), notice: 'Product collection was successfully created.' }
          format.json { render :show, status: :created, location: @product_collection }
        else
          format.html { render :new }
          format.json { render json: @product_collection.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /product_collections/1
    # PATCH/PUT /product_collections/1.json
    def update
      respond_to do |format|
        if @product_collection.update(product_collection_params)
          format.html { redirect_to office_product_collection_path(@product_collection), notice: 'Product collection was successfully updated.' }
          format.json { render :show, status: :ok, location: @product_collection }
        else
          format.html { render :edit }
          format.json { render json: @product_collection.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /product_collections/1
    # DELETE /product_collections/1.json
    def destroy
      @product_collection.destroy
      respond_to do |format|
        format.html { redirect_to office_product_collections_url, notice: 'Product collection was successfully destroyed.' }
        format.json { head :no_content }
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
