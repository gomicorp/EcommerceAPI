module ExternalChannel
  module Order
    # TODO: 방어 로직 추가
    class ExternalChannelOrderSaver < ExternalChannel::ExternalChannelSaver
      def save_all(orders)
        orders.all? {|order| save(order)}
      end

      def save(order)
        order_info = ExternalChannelOrderInfo.find_by(external_channel_order_id: order[:id])
        order_info = ExternalChannelOrderInfo.new if order_info.nil?
        order_info.update!(parse_order(order))
        set_order_related_info(order_info, order[:variant_ids]) if order_info.products.nil?
      end

      private

      def set_order_related_info(target, variant_ids)
        variant_ids.each do |variant|
          option = ProductOption.find_by(channel_code: variant[0])
          return false if option.nil?

          target.product_options << option

          order_to_option = ExternalChannelCartItem.new
          order_to_option.external_option_id = option.id
          order_to_option.option_count = variant[1]
          order_to_option.save!

          option.brands.each do |brand|
            order_to_brand = ExternalChannelOrderInfoBrand.new
            order_to_brand.brand = brand
            order_to_brand.external_channel_order_info = target
            order_to_brand.save!
          end
        end

      end

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
          cancelled_status: order[:canceled_status],
          external_channel_order_id: order[:id],
        }
      end

    end
  end
end