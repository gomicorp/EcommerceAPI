module Sellers
  module Users
    class StoreInfosController < BaseController
      before_action :authenticate_user!
      before_action :set_seller, only: %i[show update]
      before_action :check_authorization!, only: %i[update]

      def show
        render "show", locals: { store_info: @seller.seller_info.store_info }
      end

      def update
        if @seller.seller_info.store_info.update(store_info_params)
          render "update", locals: { store_info: @seller.seller_info.store_info.reload }
        else
          render json: @store_info.errors, status: :unprocessable_entity
        end
      end

      private

      def set_seller
        @seller = Seller.find(params[:user_id])

        raise ActiveRecord::RecordNotFound unless @seller
      end

      def store_info_params
        params.require(:store_info).permit(:name, :comment)
      end

      def check_authorization!
        # @seller 가 먼저 선언되어있어야 합니다.
        return true if @seller.id == current_user.id

        raise ApiController::NotAuthorized
      end

    end
  end
end
