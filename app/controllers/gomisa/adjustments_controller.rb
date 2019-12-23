module Gomisa
    class AdjustmentsController < BaseController
      # GET /gomisa/adjustments
      # GET /gomisa/adjustments.json
      def index
        @adjustments = filter_adjustments
      end

      private
      def filter_adjustments
        query = reason(params[:reason])
        if query == "All" 
          return from_to_date_filter(
            Adjustment,
            params[:from], params[:to]
          )
        end
        return from_to_date_filter(
          Adjustment.where(
            reason: query
          ),
          params[:from], params[:to]
        )
      end

      def from_to_date_filter(queryset, from, to)
        return queryset.where(exported_at: (from.to_date..to.to_date))
      end

      def reason(reason)
        return {
          'inbound' => 'Nhập hàng (From Korea)',
          'rebound' => 'Hủy đơn hàng (Order Cancel)',
          'outbound' => 'Xuất hàng (Orders)'
        }[reason] || 'All'
      end
    end
  end
