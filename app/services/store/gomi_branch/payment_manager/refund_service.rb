module Store
  module GomiBranch
    class PaymentManager

      class RefundService
        # @param payment Payment
        # @param pg Paying::PgPayment
        def initialize(payment, pg, params = nil)
          @payment = payment
          @pg = pg
          @params = params
        end

        class Revert < self

          def call
            self.refund!
            reset_payment!
          end

          # 결제를 다시하는 등의 초기화가 필요한 경우
          def reset_payment!
            @payment.update(paid: false, paid_at: nil)
          end
        end

        class Cancel < self

          def call
            self.refund!
            cancel_payment!
          end

          # 아예 주문을 취소하는 경우
          def cancel_payment!
            @payment.update!(cancelled: true, cancel_message: @params ? @params[:cancel_message] : '')
          end
        end

        protected

        def refund!
          pay_method = @payment.pay_method
          @pg.refund(@payment.charge_id, @payment.amount) if pay_method == 'card'
          @payment.pay_slips.destroy_all if pay_method == 'bank'
        end
      end
    end
  end
end
