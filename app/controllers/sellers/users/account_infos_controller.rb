module Sellers
  module Users
    class AccountInfosController < BaseController
      before_action :authenticate_user!
      before_action :set_seller
      before_action :set_account_info, only: %i[show update destroy]
      # before_action :check_authorization!, only: %i[create destroy]

      def index
        @account_infos = @seller.seller_info.account_infos

        render 'index', locals: { account_infos: @account_infos }
      end

      def create
        @account_info = AccountInfo.new(bank: set_bank,
                                        owner_name: account_info_params[:owner_name],
                                        account_number: account_info_params[:account_number],
                                        seller_info: @seller.seller_info)

        if @account_info.save
          render "create", locals: { account_info: @account_info }, status: :created
        else
          render json: @account_info.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @account_info.delete
          render "destroy", locals: { account_info: @account_info }, status: :accepted
        else
          render json: @account_info.errors, status: :unprocessable_entity
        end
      end

      def set_seller
        @seller = Seller.find(params[:user_id])
      end

      def set_bank
        Bank.find_by(country: Country.find(account_info_params[:country_id]),
                     name: account_info_params[:bank_name])
      end

      def set_account_info
        @account_info = AccountInfo.find(params[:id])
      end

      def account_info_params
        params.require(:account_info).permit(:country_id, :bank_name, :owner_name, :account_number)
      end

      def check_authorization!
        # @seller 가 먼저 선언되어있어야 합니다.
        return true if @seller.id == current_user.id

        raise ApiController::NotAuthorized
      end

    end
  end
end
