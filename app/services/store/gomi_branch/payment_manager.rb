require_relative '../paying/pg_payment'

module Store
  module GomiBranch
    # => 결제 매니저
    #
    # 결제에 관한 업무를 총괄한다.
    class PaymentManager
      attr_accessor :message, :current_service

      def initialize(payment = nil)
        @payment = payment
        @pg = Paying::PgPayment.new(order_info: @payment.order_info)
        @current_service = nil
        @errors = []
        @message = []
      end

      def status_task_set(after_status)
        @after_status = after_status

        begin
          @current_service = status_process
          current_service&.call
          change_status(@payment, @after_status) if @after_status && success?
        rescue StandardError => e
          @errors << e
          @message << e.message
        end

        success?
      end

      # boolean 결제매니저는 이 결제건의 상태를 주어진 상태로 변경할 수 있는지 확인하고,
      # 변경할 수 있는 상태라면 변경한 뒤 그 결과를 참 또는 거짓으로 반환합니다.
      def change_status(payment, target_status)
        begin
          raise CannotChangeStatusError.new("Status is already '#{target_status.humanize}'") if payment.current_status.code == target_status

          order_info = payment.order_info
          ordered_well = order_info.cart.current_status&.code == 'ordered'
          not_shipped_yet = [nil, 'ship_prepare'].include? order_info.ship_info.current_status&.code

          case target_status
          when 'pay_wait'
            raise CannotChangeStatusError.new("Order #{order_info.enc_id} has some trouble. Ask to manager.") unless ordered_well
            raise CannotChangeStatusError.new("Order #{order_info.enc_id} is already in shipping process.") unless not_shipped_yet
          when 'paid'
            raise CannotChangeStatusError.new("Order #{order_info.enc_id} is not paid yet.") unless payment.paid
          when 'refund_request'
            raise CannotChangeStatusError.new("Order #{order_info.enc_id} is already in shipping process.") unless not_shipped_yet
          when 'refund_complete'
            raise CannotChangeStatusError.new("Order #{order_info.enc_id} is not refunded yet.") unless payment.paid
          else
            raise CannotChangeStatusError.new('Status is not supplied.')
          end
        rescue CannotChangeStatusError => e
          @errors << e
          @message << e.message
          return false
        end

        payment.update_status(target_status)
        order_info.update_status(target_status) if %w[pay_wait paid].include? target_status
      end

      def self.available_statuses
        Payment::StatusCode.names.keys
      end

      private

      def status_process
        current_status = @payment.current_status&.code
        return nil unless @after_status
        return PayConfirmService.new(@payment, @pg) if @after_status == 'paid' && current_status == 'pay_wait'
        return RefundService::Cancel.new(@payment, @pg) if @after_status == 'refund_complete' && current_status == 'refund_request'
        return RefundService::Revert.new(@payment, @pg) if @after_status == 'pay_wait' && %w[refund_request paid].include?(current_status)

        nil
      end

      def success?
        @errors.empty?
      end

      class PayConfirmService
        # @param payment Payment
        # @param pg Paying::PgPayment
        def initialize(payment, pg)
          @payment = payment
          @pg = pg
        end

        def call
          pay_complete!
        end

        def pay_complete!
          if @payment.pay_method == 'bank'
            pay_slips = @payment.pay_slips
            paid_at = pay_slips&.last&.created_at || Time.zone.now
            @payment.assign_attributes(paid: true, paid_at: paid_at)
          else
            # 카드결제 시 로직이므로, 오피스에서는 쓰이지 않음
            @pg.pay_confirm_for @payment
          end
          @payment.save!
        end
      end

      class CannotChangeStatusError < StandardError
        def initialize(msg = nil)
          super(msg)
        end
      end
    end
  end
end
