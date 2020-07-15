module Sellers
  class UsersController < BaseController
    before_action :set_seller, only: %i[show]

    def show
      render json: @seller
    end

    def update
    # 프로필 이미지 업데이트
    # 생일, 성별 업데이트
    #
    end

    protected

    def set_seller
      @seller = Seller.find(params[:id])
    end
  end
end
