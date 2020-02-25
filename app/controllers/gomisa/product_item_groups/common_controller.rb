module Gomisa
  module ProductItemGroups
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

      def set_product_item_group
        @product_item_group = ProductItemGroup.find(params[:product_item_group_id])
      end
    end
  end
end
