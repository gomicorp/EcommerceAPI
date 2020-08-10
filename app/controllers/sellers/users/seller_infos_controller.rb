module Sellers
  module Users
    class SellerInfosController < BaseController
      before_action :authenticate_user!
      before_action :set_seller_info, only: %i[show]
      before_action :check_authorization!, only: %i[create update destroy]

      # = GET /sellers/users/:user_id/seller_info
      def show
        # = show.json.jbuilder
      end

      # = POST /sellers/users/:user_id/seller_info
      def create
        @service = SellerInfoCreateService.new(seller_info_service_params, current_user)

        if @service.save
          render json: @service
        else
          @errors = @service.errors

          render json: @service.errors, status: :unprocessable_entity
        end
      end

      def update; end

      private

      def set_seller_info
        @seller_info = SellerInfo.find_by(seller_id: params[:user_id])

        raise ActiveRecord::RecordNotFound unless @seller_info
      end

      def seller_info_params
        params.require(:seller_info).permit(:sns_id, :purpose)
      end

      def social_media_params
        params.require(:seller_info).permit(:sns_name)
      end

      def interest_tag_params
        params.require(:seller_info).permit(:interest_tags => [])
      end

      def store_info_params
        params.require(:seller_info).require(:store_info).permit(:name)
      end

      def seller_params
        params.require(:seller).permit(:name, :phone_number)
      end

      def seller_info_service_params
        {
            seller_info_params: seller_info_params,
            social_media_params: social_media_params,
            interest_tag_params: interest_tag_params,
            store_info_params: store_info_params,
            seller_params: seller_params
        }
      end

      def check_authorization!
        return true if params[:user_id].to_i == current_user.id

        raise ApiController::NotAuthorized
      end
    end
  end
end
