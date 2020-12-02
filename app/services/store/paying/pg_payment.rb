require_relative './thai_pg'
require_relative './korea_pg'
module Store
  module Paying
    class PgPayment
      attr_reader :params

      def initialize(params = nil)
        @params = params
        @order_info = @params&.dig(:order_info)
      end

      def gen_charge_id(payment)
        'chrg_' << payment.order_info.enc_id.downcase
      end

      def required?
        pay_method == 'card'
      end

      def checkout(checkout_amount, **args)
        cart = args.dig(:cart)
        order = args.dig(:order_info)

        # 3-D Secure 방식의 pg에서, 유저가 은행인증 완료 후 플랫폼으로 돌아오는 uri
        return_uri = args.dig(:return_uri)
        # payment의 연관 정보

        local_pg.checkout(
          cart: cart,
          order: order,
          amount: checkout_amount,
          # 결제 유저가 결제를 마친 뒤 플랫폼으로 돌아올 uri입니다. for omise_th
          return_uri: return_uri,
          # 결제 선등록에서 사용할 charge_id입니다. for iamport_ko
          charge_id: gen_charge_id(order.payment)
        )
      end

      def prepared_charge(charge_id)
        local_pg.prepared charge_id if local_pg.respond_to?(:prepared)
      end

      def pay_confirm_for(payment)
        payment.build_paid if standard_charge(payment.charge_id).paid?
      end

      def refund(charge_id, refund_amount)
        local_pg.refund(charge_id, amount: refund_amount)
      end

      def error_class
        local_pg.error_class.nil? ? PaymentError : local_pg.error_class
      end

      def standard_charge(charge_id)
        return nil unless charge_object(charge_id)

        @standard_charge ||= Paying::Charge.new charge_object(charge_id)
      end

      def charge_object(charge_id)
        @charge_object ||= local_pg.charge_object(charge_id)
      end

      def charged?(charge_id)
        !!standard_charge(charge_id)
      end

      private

      # 국가별 pg
      def local_pg
        @pg ||= case ENV['APP_COUNTRY']
                when 'th'
                  Paying::ThaiPg.new(params: params)
                when 'ko'
                  Paying::KoreaPg.new(params: params)
                end
      end

      def pay_method
        params.dig(:order_info, :payment, :pay_method) if params&.respond_to?(:dig)
      end

      def cart
        @cart ||= Cart.where(id: params.dig(:order_info, :cart_id)).first
      end

      class PaymentError < StandardError
        def name
          'payment error'
        end

        def message
          'Error is occured by payment.'
        end
      end
    end
  end
end
