module Gomisa
  module ProductCollections
    class ElementsController < CommonController
      before_action :set_product_collection
      before_action :set_elements

      def create
        if @elements.create(product_item_id: params[:product_item_id])
          render status: :created, template: "gomisa/product_collections/show", formats: :json
        end
      end

      def destroy
        puts "destroy"
        if @elements.destroy(@elements.find_by(product_item_id: params[:product_item_id]))
          render status: :no_content, template: "gomisa/product_collections/show", formats: :json
        end
      end

      private

      def set_elements
        @elements = @product_collection.elements
      end
    end
  end
end
