module Store
  module OrderInfos
    class CommonController < BaseController
      before_action :set_order_info, unless: :bulk_method?

      def show; end

      private

      def set_order_info
        @order_info = OrderInfo.find(params[:order_info_id])
      end

      def bulk_method?
        params[:order_info_id].to_s == 'bulk'
      end
      helper_method :bulk_method?

      def order_info_ids
        params[:ids].to_s.split(',').map(&:to_i) if bulk_method?
      end
    end
  end
end
