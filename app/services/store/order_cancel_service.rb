module Store
  class OrderCancelService
    attr_reader :cart, :order_info, :payment, :items, :user
    attr_reader :params, :before_status

    def initialize(cart, params, before_status)
      @cart = cart
      @order_info = cart.order_info
      @items = cart.items
      @payment = order_info.payment
      @user = cart.user

      @params = params
      @before_status = before_status
    end

    def cancel!
      ApplicationRecord.transaction do
        return false unless succeeded?(&:refund!)
        return false unless succeeded?(&:cancel_cart!)
        return false unless succeeded?(&:cancel_payment!)
        return false unless succeeded?(&:archive_item!)
      end
      success?
    end

    def remove!
      ApplicationRecord.transaction do
        return false unless succeeded?(&:archive_item!)
        return false unless succeeded?(&:remove_cart!)
        return false unless succeeded?(&:remove_order_info!)
        return false unless succeeded?(&:remove_fake_user!)
      end
      success?
    end

    def success?
      @error.nil?
    end

    def pay_method
      payment.pay_method
    end

    private

    def succeeded?(&block)
      block.call(self)
      true
    rescue pg_payment.error_class => e
      @error = e
      false
    rescue ActiveRecord::RecordNotSaved => e
      @error = e
      false
    end

    def pg_payment
      @pg_payment ||= Paying::PgPayment.new(params)
    end

    def order_status
      cart.order_status
    end

    def should_be_status
      'cancel-complete'
    end

    protected

    def credit_for_manual_order?
      payment.charge_id == 0.to_s
    end

    # ========== Program ==========

    # 1st.
    def refund!
      case pay_method
      when 'bank'
        true
      when 'card'
        # seed 데이터를 조작하기 위해 붙인 로직으로, 실 결제 데이터인 charge에는 관여하지 않습니다.
        return true if credit_for_manual_order?

        true
      end
    end

    # 2nd.
    def cancel_cart!
      if order_status == should_be_status
        true
      else
        # => CartItem 취소 처리.
        cart.items&.each(&:cancel!)
        order_info.cart.update!(order_status: should_be_status)
      end
    end

    # 3rd.
    def cancel_payment!
      cancelled_by_admin = '[Office Cancelled]' if before_status != 'cancel-request'
      cancel_message = payment.cancel_message.presence || "#{cancelled_by_admin}\n#{params[:cancel_message].presence}"

      payment.update!(
        cancelled: true,
        cancel_message: cancel_message
      )
    end

    # 4th.
    def archive_item!
      put_in_place_barcodes
    end

    def put_in_place_barcodes
      cart_items = items

      cart_items.each do |cart_item|
        # 바코드가 없으면 이하 생략
        next if cart_item.product_item_barcodes.empty?

        product_item_barcod_ids = cart_item.product_item_barcodes.pluck(:id)

        # => CartItemBarcode 연결 해제.
        ProductItemBarcode.where(id: product_item_barcod_ids).each do |barcode|
          CartItemBarcode.find_by(cart_item: cart_item, product_item_barcode: barcode).destroy!
          barcode.disexpire!
          barcode.update(leaved_at: nil)
        end

        # => 출고된 재고는 재입고된 사실을 주문서로 기록함.
        cart_item.product_option.items.each do |product_item|
          # 출고된 적이 없으면 이하 생략
          next if product_item.adjustments.where(order_info: order_info).empty?

          shipped_quantity = ProductItemBarcode.where(id: product_item_barcod_ids, product_item: product_item).count

          adjustment = Adjustment.new(
            reason: Adjustment::ORDER_CANCELLED_REASON,
            amount: shipped_quantity,
            order_info: order_info,
            memo: "(Cancelled ##{order_info.id}) #{order_info.enc_id}",
            result_quantity: product_item.barcodes_remain_count
          )

          adjustment.save!

          product_item.adjustments << adjustment
        end

      end

    end

    def remove_cart!
      cart.destroy! == cart
    end

    def remove_order_info!
      order_info.destroy! == order_info
    end

    def remove_fake_user!
      user.destroy! == user
    end
  end
end

