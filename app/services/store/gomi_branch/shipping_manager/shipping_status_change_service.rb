module Store
  module GomiBranch
    class ShippingManager
      class ShippingStatusChangeService
        attr_reader :ship_info, :order_info, :payment
        attr_reader :pay_completed, :ship_prepared, :being_shipped
        attr_reader :success, :message

        def initialize(ship_info)
          @ship_info = ship_info
          @order_info = @ship_info.order_info
          @payment = @order_info.payment

          @pay_completed = payment.status&.paid?
          @ship_prepared = current_status&.ship_prepare?
          @being_shipped = current_status&.ship_ing?
        end

        def call(target_status)
          ApplicationRecord.transaction do
            return @success = false unless changeable_status?(target_status)
            return @success = false unless pre_processing(target_status)

            # order_status = convert_ship_status_to_order_status(target_status)
            ship_info.update_status(target_status)
            order_info.update_status(target_status)
            @success = true
          end
        end

        def result
          [success, message]
        end

        private

        def current_status
          ship_info.status
        end

        def changeable_status?(target_status)
          case target_status
          when 'ship_prepare'
            pay_completed or fail_because_order 'is not paid.'
          when 'ship_ing'
            (pay_completed or fail_because_order 'is not paid.') and
              (ship_prepared or fail_because_order 'is not ready to ship.')
          when 'ship_complete'
            being_shipped or fail_because_order 'has not yet started.'
          else
            # return 관련 로직은 아직 구현되지 않음.
            fail_because_order nil, full_text: "Not supplied status for #{target_status} yet."
          end
        end

        # def convert_ship_status_to_order_status(ship_status)
        #   fail_because_order(full_text: 'System Err. Invalid shipping status. Given ship_status is "nil"') if ship_status.nil?
        #
        #   converting_table = {
        #     ship_complete: :order_complete
        #   }
        #
        #   converting_table[ship_status.to_s.to_sym] || ship_status
        # end

        def fail_because_order(msg, raising: true, full_text: nil)
          identity = "(#{order_info.class}##{order_info.id}/ #{order_info.enc_id})"
          @message = "This order #{msg} #{identity}"
          @message = "#{full_text} #{identity}" if full_text
          @success = false

          raise CannotChangeStatusError, @message if raising

          @success
        end

        def pre_processing(target_status)
          if ship_prepared && target_status == 'ship_ing'
            OutputService.new(ship_info).call
          end

          true
        end


        class Bulk
          attr_reader :order_infos

          def initialize(order_infos)
            @order_infos = order_infos
          end

          def call(target_status)
            results = []
            ApplicationRecord.transaction do
              results = order_infos.includes(:ship_info).all.collect do |order_info|
                ShippingStatusChangeService.new(order_info.ship_info).call(target_status)
              end
            end

            results
          end
        end
      end
    end
  end
end
