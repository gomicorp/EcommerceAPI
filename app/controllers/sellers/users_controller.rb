module Sellers
  class UsersController < BaseController
    before_action :authenticate_user!
    before_action :set_seller, only: %i[show update destroy]
    before_action :check_authorization!, only: %i[update destroy]

    # = GET /sellers/users
    def index; end

    # = GET /sellers/users/:id
    def show
      render "show", locals: { seller: @seller }
    end

    # = POST /sellers/users
    def create; end

    # = PATCH /sellers/users/:id
    def update
      # 프로필 이미지 업데이트
      # 생일, 성별 업데이트
      # 관심 태그 업데이트
      @service = SellerUpdateService.new(seller_service_params, current_user)

      if @service.save
        render "update", locals: { seller: @seller.reload }
        # render json: @seller.reload, status: :ok
      else
        render json: @seller.errors, status: :unprocessable_entity
      end
    end

    # = DELETE /sellers/users/:id
    def destroy
      @seller.seller_info.destroy
      @seller.carts.delete_all
      @seller.destroy
    end

    private

    def set_seller
      @seller = Seller.find(params[:id])

      raise ActiveRecord::RecordNotFound unless @seller
    end

    def seller_params
      params.require(:seller).permit(:birth_day, :gender, :name, :profile_image)
    end

    def seller_email_params
      params.require(:seller).permit(:seller_email)
    end

    def interest_tag_params
      params.require(:seller).permit(:interest_tags => [])
    end

    def seller_service_params
      {
          seller_params: seller_params,
          seller_email_params: seller_email_params,
          interest_tag_params: interest_tag_params
      }
    end

    def check_authorization!
      # @seller 가 먼저 선언되어있어야 합니다.
      return true if @seller.id == current_user.id

      raise ApiController::NotAuthorized
    end
  end
end
