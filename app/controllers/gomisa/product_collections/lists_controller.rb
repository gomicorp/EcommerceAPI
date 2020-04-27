module Gomisa
  module ProductCollections
    class ListsController < CommonController
      before_action :set_product_collection
      before_action :set_product_collection_list, only: %i[show edit update destroy]

      # 현재 등록할수 있는 item들을 반환한다.
      def index
        @allowed_product_items = ProductItem.where.not(id: @product_collection.lists.pluck(:item_id)).pluck(:name, :id)
      end

      def create
        @product_collection_list = @product_collection.lists.build(product_collection_list_params)
        ActiveRecord::Base.transaction do
          @product_collection_list.unit_count.times do
            @product_collection.items << @product_collection_list.item
          end
        end

        @product_collection_list = ProductCollectionList.find(@product_collection_list.item_id)

        # 어짜피 위에서 저장안되면 422 status code 반환
        render status: :created, template: "gomisa/product_collections/show", formats: :json
      end

      def destroy
        elements = @product_collection.elements.where(product_item: @product_collection_list.item)
        @product_collection.elements.destroy(elements)
        render status: :no_content, template: "gomisa/product_collections/show", formats: :json
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
