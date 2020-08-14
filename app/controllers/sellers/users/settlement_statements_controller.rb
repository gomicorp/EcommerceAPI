module Sellers
  module Users
    class SettlementStatementsController < BaseController
      before_action :authenticate_user!
      before_action :set_seller
      before_action :check_authorization!
      before_action :set_account_info, only: %i[create]

      def index
        @settlement_statements = @seller.seller_info.settlement_statements.ransack(params[:query]).result
        # = index.json.jbuilder
      end

      def create
        @settlement_statement = Sellers::SettlementStatement.new(settlement_statement_params).tap do |statement|
          statement.assign_attributes(
            seller_info: @seller.seller_info,
            status: 'requested'
          )
          statement.capture_account(@account_info)
        end
        # 데이터 검증 후 저장을 해보고 실패시 에러
        unless @settlement_statement.valid_before_create && @settlement_statement.save! && @settlement_statement.write_initial_state
          render json: {error: 'bad request'}, status: :bad_request
        end
      end

      private

      def set_seller
        @seller ||= Seller.find(params[:user_id])
      end

      def set_account_info
        @account_info = Sellers::AccountInfo.where(account_info_params).first
      end

      def check_authorization!
        return true if params[:user_id].to_i == current_user.id

        raise ApiController::NotAuthorized
      end

      def settlement_statement_params
        params.require(:settlement_statement).permit(:settlement_amount)
      end

      def account_info_params
        params.require(:account_info).permit(:seller_info_id, :bank_id, :owner_name, :account_number)
      end
    end
  end
end
