module Sellers
  class SellerUpdateService
    def initialize(service_params, seller)
      @seller = Seller.find seller.id
      @seller_params = service_params[:seller_params]
      @interest_tag_params = service_params[:interest_tag_params]

      @errors = nil
    end

    def save
      begin
        ApplicationRecord.transaction do
          # 1. update seller
          @seller.assign_attributes(@seller_params)
          valid_save @seller

          # 2. create user_interest_tags
          @user_interest_tags = []
          @interest_tag_params[:interest_tags].each do |tag_name|
            @user_interest_tags << UserInterestTag.new(user: @seller, interest_tag: InterestTag.find_by(name: tag_name))
          end
          valid_save @user_interest_tags

          raise ActiveRecord::Rollback if @errors
        end
      end

      @seller.interest_tags.any?
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
