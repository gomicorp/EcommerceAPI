module Store
  module GomiBranch
    class ShippingManager
      # => 배송 매니저의 출고 서비스
      class OutputService
        attr_reader :ship_info, :order_info

        # 출고 서비스를 위해 주문 정보가 필요합니다.
        def initialize(ship_info_or_order_info)
          case ship_info_or_order_info
          when OrderInfo
            @order_info = ship_info_or_order_info
            @ship_info = @order_info.ship_info
          when ShipInfo
            @ship_info = ship_info_or_order_info
            @order_info = @ship_info.order_info
          else
            raise ArgumentError, 'OutputService should receive OrderInfo or ShipInfo instance for it\'s initializer.'
          end
        end

        # void | 배송건을 출고하는 방법을 정의합니다.
        def call(leaved_at: Time.zone.now.dup)
          fail_because_shipping('Put "Tracking Number" first.', full_text: true) if ship_info.tracking_number.nil?

          ApplicationRecord.transaction do
            # 해당 장바구니의 각 아이템을 돌면서
            cart_items = order_info.cart.items
            cart_items.each do |cart_item|

              # 아이템에 맞물린 SKU 들에 대하여
              entities = cart_item.product_item_entities

              # 해당 재고들에 출고 일시를 기록하고
              entities.update_all(leaved_at: leaved_at)

              # SKU 를 기준으로 재고 분류를 합니다.
              grouped_product_item_entities = cart_item.product_item_entities.group_by(&:product_item_id)
              grouped_product_item_entities.each do |product_item_id, product_item_entities|

                # SKU 단위로 출고 요청서를 생성합니다.
                item = ProductItem.find(product_item_id)
                adjustment = Adjustment.new(amount: product_item_entities.length * -1, country: item.country)

                adjustment.reason = Adjustment::ORDER_REASON
                adjustment.order_info = @order_info
                adjustment.memo = "(##{@order_info.id}) #{@order_info.enc_id} |\n"
                adjustment.result_quantity = item.entities_remain_count
                adjustment.save!

                item.adjustments << adjustment
              end

            end
            # 외부 배송 추적 서비스에 트래킹을 생성합니다.
            create_tracking!
          end
        end

        private

        def create_tracking!
          ship_info.update(carrier_code: 'alphafast') if ship_info.carrier_code.nil?
          Shipping::Tracking.create(ship_info.tracking_number, ship_info.carrier_code)
        end

        def fail_because_shipping(msg, raising: true, full_text: nil)
          identity = "(#{ship_info.class}##{ship_info.id})"
          @message = "This shipping #{msg} #{identity}"
          @message = "#{full_text} #{identity}" if full_text
          @success = false

          raise CannotOutputError, @message if raising

          @success
        end
      end
    end
  end
end
