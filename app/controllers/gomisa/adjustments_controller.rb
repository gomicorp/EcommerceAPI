module Gomisa
    class AdjustmentsController < BaseController
      # GET /gomisa/adjustments
      # GET /gomisa/adjustments.json
      def index
        @adjustments = filter_adjustments
      end

      private
      # Use callbacks to share common setup or constraints between actions.
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
        # 수정하기
        # 로직을 이렇게 짜서 if else 가 안길어지게 하자
        # {
        #   'inbound' => '',
        #   'rebound' => ''
        # }[reason] || 'All'
        if reason == "inbound"
          return "Nhập hàng (From Korea)"
        elsif reason == "rebound"
          return "Hủy đơn hàng (Order Cancel)"
        elsif reason == "outbound"
          return "Xuất hàng (Orders)"
        else
          return "All"
        end
      end
    end
  end
