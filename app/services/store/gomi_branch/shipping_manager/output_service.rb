module Store
  module GomiBranch
    class ShippingManager
      # => 배송 매니저의 출고 서비스
      class OutputService

        # 출고 서비스를 위해 주문 정보가 필요합니다.
        def initialize(order_info)
          @order_info = order_info
        end

        # void
        def call(leaved_at: Time.zone.now.dup)
          ApplicationRecord.transaction do
            # 해당 장바구니의 각 아이템을 돌면서
            cart_items = @order_info.cart.items
            cart_items.each do |cart_item|

              # 아이템에 맞물린 SKU 들을 기준으로 재고 분류를 합니다.
              grouped_product_item_barcodes = cart_item.product_item_barcodes.group_by(&:product_item_id)
              grouped_product_item_barcodes.each do |product_item_id, product_item_barcodes|

                # 해당 재고들에 출고 일시를 기록하고

                product_item_barcodes.each { |barcode| barcode.update(leaved_at: leaved_at) }

                # SKU 단위의 출고 요청서를 생성합니다.

                item = ProductItem.find(product_item_id)
                adjustment = Adjustment.new(amount: product_item_barcodes.length * -1, country: item.country)

                adjustment.reason = Adjustment::ORDER_REASON
                adjustment.order_info = @order_info
                adjustment.memo = "(##{@order_info.id}) #{@order_info.enc_id} |\n"
                adjustment.result_quantity = item.barcodes_remain_count
                adjustment.save!

                item.adjustments << adjustment
              end
            end
          end
        end
      end
    end
  end
end
