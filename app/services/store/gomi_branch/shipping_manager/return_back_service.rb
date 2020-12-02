module Store
  module GomiBranch
    class ShippingManager
      # => 배송 매니저의 출고 취소(재입고) 서비스
      class ReturnBackService

        # 재입고 서비스를 위해 주문 정보가 필요합니다.
        def initialize(order_info)
          @order_info = order_info
        end

        # void
        def call
          ApplicationRecord.transaction do
            cart_items = @order_info.cart.items
            cart_items.each do |cart_item|

              grouped_product_item_barcodes = cart_item.product_item_barcodes.group_by(&:product_item_id)
              grouped_product_item_barcodes.each do |product_item_id, product_item_barcodes|

                product_item_barcodes.each { |barcode| barcode.update(leaved_at: nil) }

                item = ProductItem.find(product_item_id)
                adjustment = Adjustment.new(amount: product_item_barcodes.length, country: item.country)

                adjustment.reason = Adjustment::ORDER_CANCELLED_REASON
                adjustment.order_info = @order_info
                adjustment.memo = "CANCELLED (##{@order_info.id}) #{@order_info.enc_id} |\n"
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
