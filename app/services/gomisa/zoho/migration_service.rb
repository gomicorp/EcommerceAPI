module Gomisa
  module Zoho
    class MigrationService
      include ZohoRequest
      
      def initialize
        set_access_token
        @item_saver = ProductItemSaver.new(access_token)
        @item_container_saver = ProductItemContainerSaver.new(access_token)
        @adjustment_saver = AdjustmentSaver.new(access_token)
      end

      def call
        @item_saver.call
        @item_container_saver.call
        @adjustment_saver.call
      end

      private

      def access_token
        $access_token ||= set_access_token
      end

      def set_access_token
        $access_token = refresh_access_token
      end

      def refresh_access_token
        get_new_access_token
      end
    end
  end
end
