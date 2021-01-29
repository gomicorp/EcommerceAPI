module ExternalChannel
  module Order
    # TODO: 방어 로직 추가
    class Saver < BaseSaver
      protected

      def save_data(order)
        order_info = ExternalChannel::OrderInfo.find_or_initialize_by(external_channel_order_id: order[:id])
        order_info.update!(parse_order(order))

        set_order_related_info(order_info, order) 
        true
      end

      private

      def set_order_related_info(target, order)
        variant_ids = order[:variant_ids]
        variant_ids.each do |variant|
          option = ::ProductOption.find_by(channel_code: variant[0])
          raise ActiveRecord::RecordNotFound, "On #{order[:channel]}, #{order[:order_number]}-#{variant[0]} option not found" if option.nil?

          order_to_option = ExternalChannel::CartItem.find_or_initialize_by(order_info_id: target.id, product_option_id: option.id)
          order_to_option.option_count = variant[1]
          order_to_option.unit_price = variant[2]
          order_to_option.save!
          
          option.brands.each do |brand|
            ExternalChannel::OrderInfoBrand.find_or_create_by!(brand: brand, order_info: target)
          end
        end
      end

      def parse_order(order, default_order = {})
        # TODO: 모델 구조 변경시 변경 필요
        {
          country: Country.send(ApplicationRecord.country_code),
          receiver_name: order[:receiver_name],
          total_price: order[:billing_amount],
          ordered_at: default_order[:ordered_at] || order[:ordered_at],
          pay_method: order[:pay_method],
          channel: order[:channel],
          paid_at: order[:paid_at] || default_order[:paid_at],
          order_status: order[:order_status],
          ship_fee: order[:ship_fee],
          order_number: order[:order_number],
          cancelled_status: order[:cancelled_status] || default_order[:shipping_status],
          external_channel_order_id: order[:id],
          shipping_status: order[:shipping_status] || default_order[:shipping_status],
          row_data: order[:row_data]
        }
      end
    end
  end
end
