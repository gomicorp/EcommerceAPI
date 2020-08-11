module Sellers
  module Users
    class SettlementStatementsController < BaseController
      before_action :authenticate_user!
      before_action :set_seller
      before_action :check_authorization!

      def index
        @settlement_statements = @seller.seller_info.settlement_statements.ransack(params[:query]).result
        # = index.json.jbuilder
      end

      private

      def set_seller
        @seller ||= Seller.find(params[:user_id])
      end

      def check_authorization!
        return true if params[:user_id].to_i == current_user.id

        raise ApiController::NotAuthorized
      end
    end
  end
end
