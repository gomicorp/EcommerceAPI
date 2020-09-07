module Partner
  module Brands
    class ProductItemGroupsController < BaseController
      before_action :set_product_item_group, only: %i[show update destroy]

      # GET /partner/brands/1/product_item_groups
      # GET /partner/brands/1/product_item_groups.json
      def index
        @product_item_groups = @brand.product_item_groups.all
      end

      # GET /partner/brands/1/product_item_groups/1
      # GET /partner/brands/1/product_item_groups/1.json
      def show
      end

      # POST /partner/brands/1/product_item_groups
      # POST /partner/brands/1/product_item_groups.json
      def create
        @product_item_group = ProductItemGroup.new(product_item_group_params.merge(brand: @brand))

        if @product_item_group.save
          render :show, status: :created, location: [:partner, @brand, @product_item_group]
        else
          render json: @product_item_group.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /partner/brands/1/product_item_groups/1
      # PATCH/PUT /partner/brands/1/product_item_groups/1.json
      def update
        if @product_item_group.update(product_item_group_params)
          render :show, status: :ok, location: [:partner, @brand, @product_item_group]
        else
          render json: @product_item_group.errors, status: :unprocessable_entity
        end
      end

      # DELETE /partner/brands/1/product_item_groups/1
      # DELETE /partner/brands/1/product_item_groups/1.json
      def destroy
        @product_item_group.destroy
      end


      private

      # Use callbacks to share common setup or constraints between actions.
      def set_product_item_group
        @product_item_group = @brand.product_item_groups.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_item_group_params
        params.require(:product_item_group).permit(:name, items_attributes: [*ProductItem.attribute_names, :_destroy, images: []])
      end
    end
  end
end
