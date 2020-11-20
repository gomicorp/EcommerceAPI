module GomiBranch
  # => 배송 매니저
  #
  # 배송에 관한 업무를 총괄한다.
  class ShippingManager
    attr_accessor :message, :current_service

    DELIVERY_COMPLETE_CODE = %w[Delivered AvailableForPickup]

    def initialize(ship_info = nil)
      @ship_info = ship_info
      @current_service = nil
      @errors = []
      @message = []
    end

    def status_task_set(after_status)
      @after_status = after_status

      begin
        @current_service = status_process
        current_service&.call
        change_status(@ship_info, @after_status) if @after_status && success?
      rescue StandardError => e
        @errors << e
        @message << e.message
      end

      success?
    end

    # void 배송 매니저는
    # 주문 정보를 CS 로부터 전달 받아, 출고 처리를 합니다.
    def output(order_info)
      ship_info = order_info.ship_info
      OutputService.new(order_info).call
      Shipping::Tracking.create(ship_info.tracking_number, ship_info.carrier_code)
    end

    def update_tracking_info(ship_infos = nil)
      ship_infos ||= [@ship_info]
      ship_infos.each do |ship_info|
        carrier_code = ship_info.carrier_code
        tracking_number = ship_info.tracking_number
        tracking_status_code = Shipping::Tracking.find(tracking_number, carrier_code).code
        change_status(ship_info, 'ship_complete') if DELIVERY_COMPLETE_CODE.include? tracking_status_code
      end
    end

    # void 배송 매니저는 주문이 배송 나간 뒤 취소된 경우에,
    # 주문 정보를 CS 로부터 전달 받아, 출고 취소(재입고) 처리를 합니다.
    def return_back(order_info)
      ReturnBackService.new(order_info).call
    end

    # boolean 배송매니저는 이 배송건의 상태를 주어진 상태로 변경할 수 있는지 확인하고,
    # 변경할 수 있는 상태라면 변경한 뒤 그 결과를 참 또는 거짓으로 반환합니다.
    def change_status(ship_info, target_status)
      begin
        if ship_info.current_status&.code == target_status
          raise CannotChangeStatusError, "Status is already '#{target_status.humanize}'"
        end

        order_info = ship_info.order_info
        payment = order_info.payment
        pay_completed = payment.status&.paid?
        ship_prepared = ship_info.status&.ship_prepare?
        being_shipped = ship_info.status&.ship_ing?

        case target_status
        when 'ship_prepare'
          raise CannotChangeStatusError, "Order #{order_info.enc_id} is not paid." unless pay_completed
        when 'ship_ing'
          raise CannotChangeStatusError, "Order #{order_info.enc_id} is not paid." unless pay_completed
          raise CannotChangeStatusError, "Order #{order_info.enc_id} is not ready to ship." unless ship_prepared
        when 'ship_complete'
          raise CannotChangeStatusError, "Order #{order_info.enc_id}'s shipping is not complete." unless being_shipped
        else
          # return 관련 로직은 아직 구현되지 않음.
          raise CannotChangeStatusError, 'Not supplied yet.'
        end
      rescue CannotChangeStatusError => e
        @errors << e
        @message << e.message
        return false
      end

      ship_info.update_status(target_status) && order_info.update_status(target_status)
    end

    def self.available_statuses
      ShipInfo::StatusCode.names.keys
    end

    private

    def status_process
      current_status = @ship_info.status
      return nil unless @after_status
      return OutputService.new(@ship_info.order_info) if @after_status == 'ship_ing' && current_status&.ship_prepare?

      nil
    end

    def success?
      @errors.empty?
    end


    class CannotChangeStatusError < StandardError
      def initialize(msg = nil)
        super(msg)
      end
    end
  end
end
