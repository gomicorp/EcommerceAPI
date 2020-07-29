module Sellers
  class UsersController < BaseController
    before_action :set_seller, only: %i[show]

    # = GET /sellers/users
    def index; end

    # = GET /sellers/users/:id
    def show
      render json: @seller
    end

    # = POST /sellers/users
    def create; end

    # = PUT /sellers/users/:id
    def update
    # 프로필 이미지 업데이트
    # 생일, 성별 업데이트
    #
    end

    # = DELETE /sellers/users/:id
    def destroy; end

    protected

    def set_seller
      @seller = Seller.find(params[:id])
    end
  end
end
