module Gomisa
  module ProductItemGroups
    class ItemsController < CommonController
      before_action :set_product_item_group
      before_action :set_product_item, only: %i[show edit update destroy]

      def update
        update_service = Gomisa::ProductItemGroupService::ItemUpdateService.new(@product_item, product_item_params)
        if update_service.call
          render :show, status: :reset_content
        else
          render json: {"error": "product_item_group not saved"}, status: :bad_request
        end
      end

      private

      def set_product_item
        @product_item = @product_item_group.items.find(params[:id])
      end

      def product_item_params
        params.require(:product_item).permit(:serial_number, :selling_price, :cost_price, :image, :active)
      end
    end
  end
end
