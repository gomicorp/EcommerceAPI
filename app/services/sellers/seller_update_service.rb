module Sellers
  class SellerUpdateService
    attr_reader :errors

    def initialize(service_params, seller)
      @seller = Seller.find seller.id
      @seller_params = service_params[:seller_params]
      @seller_email_params = service_params[:seller_email_params]
      @interest_tag_params = service_params[:interest_tag_params]

      @errors = nil
    end

    def save
      begin
        ApplicationRecord.transaction do
          # 1. update seller
          @seller.update!(@seller_params) if @seller_params.present?

          @seller.seller_info.update(@seller_email_params) if @seller_email_params.present?

          # 2. create user_interest_tags
          @seller.interest_tags = InterestTag.where(name: interest_tag_params_names) if interest_tag_params_names.present?
        end
      end

      return true

    rescue ActiveRecord::ActiveRecordError => e
      # 이곳은 깨졌을 때만 실행되는 에러 핸들링 구역입니다.
      @errors = e
      return false
    end

    private def interest_tag_params_names
      @interest_tag_params[:interest_tags]
    end
  end
end
