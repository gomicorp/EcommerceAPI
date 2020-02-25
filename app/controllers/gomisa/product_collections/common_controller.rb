module Gomisa
  module ProductCollections
    class CommonController < BaseController
      def index
      end

      def show
      end

      def new
      end

      def create
      end

      def edit
      end

      def destroy
      end

      private

      def set_product_collection
        @product_collection = ProductCollection.find(params[:product_collection_id])
      end
    end
  end
end
