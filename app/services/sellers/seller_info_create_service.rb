module Sellers
  class SellerInfoCreateService
    attr_reader :errors

    def initialize(service_params, seller)
      @seller = Seller.find seller.id
      @seller_info_params = service_params[:seller_info_params]
      @interest_tag_params = service_params[:interest_tag_params]
      @store_info_params = service_params[:store_info_params]
      @seller_params = service_params[:seller_params]   # = 셀러 정보 업데이트는 save 메소드에서 진행합니다.

      @errors = nil

      # = 셀러 정보 생성
      @seller_info = SellerInfo.new(@seller_info_params)

      # = 팝업 스토어 정보 생성
      @store_info = StoreInfo.new(@store_info_params)
    end

    def save
      ApplicationRecord.transaction do
        # 0. Associations
        @seller_info.seller = @seller
        @seller_info.grade = Grade.first
        @store_info.seller_info = @seller_info

        # 1. save seller_info
        @seller_info.save!

        # 2. save interest_tags
        save_interest_tags

        # 3. save store_info
        @store_info.save!
        @store_info.update!(url: 'https://gomistore.in.th/popup_store/' + @store_info.id.to_s)

        # 4. update seller
        @seller.update!(@seller_params)

        # 5. create seller_info_interest_tags
        @seller_info.interest_tags << @interest_tags
      end

      # 이곳은 정상실행 됐을때만 실행되는 안전구역 입니다.
      return true

    rescue ActiveRecord::ActiveRecordError => e
      # 이곳은 깨졌을 때만 실행되는 에러 핸들링 구역입니다.
        @errors = e
      return false
    end

    private

    # = 관심 태그 생성
    private def save_interest_tags
      # a. create, update, destroy 는 루프를 돌면서 실행하면 많이 느리다.
      # b. 중복된 값을 허용하면 안된다.
      names_already_exists = InterestTag.where(name: interest_tag_params_names).pluck(:name)
      names_to_be_create = interest_tag_params_names - names_already_exists
      # ['', ''] => [{}, {}]
      interest_tag_objects = names_to_be_create.map { |name| { name: name, created_by: 'user' } }
      InterestTag.create!(interest_tag_objects)

      @interest_tags = InterestTag.where(name: interest_tag_params_names)
    end

    private def interest_tag_params_names
      @interest_tag_params[:interest_tags]
    end
  end
end