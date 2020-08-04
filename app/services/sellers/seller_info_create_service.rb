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

      # = 관심 태그 생성
      @interest_tags = []
      @seller_info_interest_tags = []

      @interest_tag_params[:interest_tags].each do |tag_name|
        @interest_tags << InterestTag.find_or_initialize_by(name: tag_name) do |interest_tag|
          interest_tag.created_by = "user"
        end
      end

      # = 팝업 스토어 정보 생성
      @store_info = StoreInfo.new(@store_info_params)
    end

    def save
      begin
        ApplicationRecord.transaction do
          # 0. Associations
          @seller_info.seller = @seller
          @seller_info.grade = Grade.first
          @store_info.seller_info = @seller_info

          # 1. save seller_info
          valid_save @seller_info

          # 2. save interest_tags
          valid_save @interest_tags

          # 3. save store_info
          valid_save @store_info
          @store_info.update(url: 'https://gomistore.in.th/popup_store/' + @store_info.id.to_s)

          # 4. update seller
          @seller.assign_attributes(@seller_params)
          valid_save @seller

          # 5. create seller_info_interest_tags
          @interest_tags.each do |interest_tag|
            @seller_info_interest_tags << SellerInfoInterestTag.new(seller_info: @seller_info, interest_tag: interest_tag)
          end
          valid_save @seller_info_interest_tags

          raise ActiveRecord::Rollback if @errors
        end
      end

      SellerInfo.where(id: @seller_info.id).any?
    end

    private

    def valid_save(record)
      if record.is_a? Array
        record.each { |rec| rec.save! if valid_record? rec }
      else
        record.save! if valid_record? record
      end
    end

    def valid_record?(record)
      if record.invalid?
        @errors = record.errors
        false
      else
        true
      end
    end

  end
end