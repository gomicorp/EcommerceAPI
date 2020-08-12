module Sellers
  module Users
    class ItemSoldPapersController < BaseController
      before_action :authenticate_user!
      before_action :set_seller_info, only: %i[index show sum]

      def index
        @item_sold_papers = @seller_info.item_sold_papers.ransack(params[:query]).result.paid
      end

      def sum
        @item_sold_papers = @seller_info.item_sold_papers.ransack(params[:query]).result.paid
      end

      private

      def set_seller_info
        @seller_info = SellerInfo.find_by(seller_id: params[:user_id])

        raise ActiveRecord::RecordNotFound unless @seller_info
      end

    end
  end
end
