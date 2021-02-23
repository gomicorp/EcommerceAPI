module Store
  module GomiBranch
    # => 배송 매니저
    #
    # 배송에 관한 업무를 총괄한다.
    class ShippingManager
      attr_reader :ship_info
      attr_accessor :message, :current_service
      attr_reader :errors

      DELIVERY_COMPLETE_CODE = %w[Delivered AvailableForPickup]

      def initialize(ship_info = nil)
        @ship_info = ship_info
        @current_service = nil
        @errors = []
        @message = []
      end

      def success?
        !has_error?
      end

      def has_error?
        @errors.is_a?(Array) ? @errors.any? : @errors.present?
      end

      def update_ship_info(ship_info_params)
        ApplicationRecord.transaction do
          # 송장번호를 업로드 한 경우,
          if ship_info_params[:tracking_number].present?

            # 처음 업로드 하는 거라면
            if create_context_for_tracking_number?(ship_info_params)
              ship_info.update(tracking_number: ship_info_params[:tracking_number], carrier_code: ship_info_params[:carrier_code])

              # 배송 중인 상태로 넘겨줍니다.
              change_status 'ship_ing'
            else
              # 트래킹 정보를 업데이트 해즙니다.
              Shipping::Tracking.update(ship_info_params[:tracking_number], ship_info.carrier_code) if ship_info.trackable?
            end
          end

          # 레코드에 대한 업데이트는 어떤 경우든 공통적으로 처리해준다.
          ship_info.update(ship_info_params)
        end
      rescue => e
        @errors = e
        @message = e.message
      ensure
        nil # void
      end

      # void 배송 매니저는
      # 주문 정보를 CS 로부터 전달 받아, 출고 처리를 합니다.
      # ship_info에 따른 배송 추적을 세팅합니다.
      def output!(order_info_or_ship_info = nil)
        OutputService.new(order_info_or_ship_info || ship_info).call
      end

      # void 배송 매니저는 주문이 배송 나간 뒤 취소된 경우에,
      # 주문 정보를 CS 로부터 전달 받아, 출고 취소(재입고) 처리를 합니다.
      def return_back(order_info)
        ReturnBackService.new(order_info).call
      end

      # boolean 배송매니저는 이 배송건의 상태를 주어진 상태로 변경할 수 있는지 확인하고,
      # 변경할 수 있는 상태라면 변경한 뒤 그 결과를 참 또는 거짓으로 반환합니다.
      def change_status(target_status, bulk: false)
        service = if bulk
                    order_infos = bulk
                    ShippingStatusChangeService::Bulk.new(order_infos)
                  else
                    ShippingStatusChangeService.new(ship_info)
                  end
        results = [service.call(target_status)].flatten
      rescue CannotChangeStatusError, CannotOutputError => e
        @errors = e
        @message = e.message
      ensure
        results
      end

      def self.available_statuses
        ShipInfo::StatusCode.names.keys
      end

      private

      def create_context_for_tracking_number?(ship_info_params)
        ship_info.tracking_number.nil? && ship_info_params[:tracking_number].present?
      end


      class CannotChangeStatusError < StandardError
        def initialize(msg = nil)
          super(msg)
        end
      end

      class CannotOutputError < StandardError
        def initialize(msg = nil)
          super(msg)
        end
      end
    end
  end
end
