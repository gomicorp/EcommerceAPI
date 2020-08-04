module Sellers
  module Products
    class SelectsController < BaseController
      before_action :authenticate_user!
      before_action :set_select_product, only: %i[create destroy]
      before_action :set_store_info, only: %i[create destroy]

      def create
        @selected_product = SelectedProduct.create(store_info: @store_info, product: @product)
      end

      def destroy
        @removed_product = SelectedProduct.destroy_by(store_info: @store_info, product: @product)
      end

      private

      def set_select_product
        @product = Product.find(params[:product_id])
      end

      def set_store_info
        @store_info ||= Seller.find(current_user.id).seller_info.store_info
      end
    end
  end
end
