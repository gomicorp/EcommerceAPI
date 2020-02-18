module Gomisa
  module ProductCollections
    class ListsController < CommonController
      before_action :set_product_collection
      before_action :set_product_collection_list, only: %i[show edit update destroy]

      def index
      end

      def new
        @product_collection_list = @product_collection.lists.build(unit_count: 1)
      end

      def create
        @product_collection_list = @product_collection.lists.build(product_collection_list_params)
        ActiveRecord::Base.transaction do
          @product_collection_list.unit_count.times do
            @product_collection.items << @product_collection_list.item
          end
        end

        @product_collection_list = ProductCollectionList.find(@product_collection_list.item_id)

        if @product_collection_list.persisted?
          render json: @product_collection, status: :created
        else
          render json: @product_collection_list.errors, status: :bad_request
        end

        #if @company.save
        #  render json: @company, status: :created
        #else
        #  render json: @company.errors, status: :unprocessable_entity
        #end
        # 새로운 튜플이 아니거나
        # 삭제되지 않으면 false
      end

      def destroy
        elements = @product_collection.elements.where(product_item: @product_collection_list.item)
        @product_collection.elements.destroy(elements)
        return redirect_back fallback_location: office_product_collection_path(@product_collection), notice: 'Collection Elements has been successfully destroyed.'
      end

      private

      def set_product_collection_list
        @product_collection_list = @product_collection.lists.find(params[:id])
      end

      def product_collection_list_params
        params.require(:product_collection_list).permit(:item_id, :unit_count)
      end
    end
  end
end
