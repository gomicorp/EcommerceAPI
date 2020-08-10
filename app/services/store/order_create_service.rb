# seed data를 생성하기 위해 존재하는 service입니다.
module Store
  class OrderCreateService
    attr_accessor :order_info, :ship_info, :payment, :cart, :seller
    attr_reader :errors

    def initialize(seller, order_info_source, ship_info_source, payment_source)
      @seller = seller
      @order_info = OrderInfo.new(order_info_source)
      @ship_info = ShipInfo.new(ship_info_source)
      @payment = Payment.new(payment_source)
      @cart = order_info.cart

      @errors = nil
    end

    def save
      return true if cart.cannot_create_order

      begin
        ApplicationRecord.transaction do
          # 0. Associations
          payment.order_info = order_info
          ship_info.order_info = order_info

          # 1. save ship_info
          valid_save ship_info

          # 2. save order_info
          order_info.enc_id ||= OrderInfo.gen_enc_id
          order_info.ordered_at ||= DateTime.now
          valid_save order_info

          # 3. save payment
          payment.write_self
          valid_save payment

          # 4. update cart status
          checkout_cart
          valid_save cart

          # 5. capture price fields into cart items
          cart.items.each(&:capture_price_fields!)

          # 6. update seller's info
          item_sold_papers = cart.items.map(&:item_sold_paper).compact
          item_sold_papers.each(&:order!)

          raise ActiveRecord::Rollback if errors
        end
      rescue ActiveRecord::RecordNotUnique => e
        ap e.message
        errors = e
        dup_order_defence
        return true
      end

      OrderInfo.where(id: order_info.id).any?
    end

    def rollback!
      ship_info.destroy if ship_info.persisted?
      payment.destroy if payment.persisted?
      recall_cart if cart
      order_info.destroy
    end

    def self.checkout_cart(cart)
      cart.update(
        order_status: 'pay',
        current: false
      )
    end

    private

    def valid_save(record)
      record.save! if valid_record? record
    end

    def valid_record?(record)
      if record.invalid?
        @errors = record.errors
        false
      else
        true
      end
    end

    def checkout_cart
      cart.order_status = payment.paid ? 'paid' : 'pay'
      cart.current = false
    end

    def recall_cart
      cart.update(
        order_status: 0,
        current: true
      )
    end

    def dup_order_defence
      @cart = cart.reload
      @order_info = cart.order_info
      @ship_info = order_info.ship_info
      @payment = order_info.payment
    end
  end
end