module ExternalChannel
  module Order
    # TODO: 방어 로직 추가
    class ExternalChannelOrderSaver < ExternalChannel::ExternalChannelSaver
      def save_all(orders)
        orders.all? {|order| save(order)}
      end

      def save(order)
        order_info = HaravanOrderInfo.find_or_create_by(haravan_order_id: order[:id])
        order_info.update!(parse_order(order))
      end

      private

      def parse_order(order)
        # TODO 모델 구조 변경시 변경 필요
        {
          total_price: order[:billing_amount],
          ordered_at: order[:ordered_at],
          pay_method: order[:pay_method],
          channel: order[:channel],
          paid_at: order[:paid_at],
          order_status: order[:order_status],
          ship_fee: order[:ship_fee],
          order_number: order[:order_number],
          cancelled_status: order[:canceled_status]
        }
      end

    end
  end
end