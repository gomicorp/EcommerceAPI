class SetStatusByStatusLoggable < ActiveRecord::Migration[6.0]
  STATUS_MAP = {
    hand: {
      Cart: 'hand',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: nil
    },
    desk: {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: nil
    },
    pay: {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: 'pay_wait',
      OrderInfo: 'pay_wait'
    },
    paid: {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: 'paid',
      OrderInfo: 'paid'
    },
    # 없음
    ship_ready: {
      Cart: 'ordered',
      ShipInfo: 'ship_prepare',
      Payment: 'paid',
      OrderInfo: 'ship_prepare'
    },
    # 없음
    ship_ing: {
      Cart: 'ordered',
      ShipInfo: 'ship_ing',
      Payment: 'paid',
      OrderInfo: 'ship_ing'
    },
    complete: {
      Cart: 'archived',
      ShipInfo: 'ship_complete',
      Payment: 'paid',
      OrderInfo: 'order_complete'
    },
    'cancel-request': {
      Cart: 'ordered',
      ShipInfo: nil,
      # 결제 대기 상태일 때 취소 했을 수도 있고, 결제 완료 후 최소했을 수도 있다.
      Payment: { not_paid: 'pay_wait', paid: 'paid' },
      OrderInfo: 'cancel_request'
    },
    # 없음
    'cancel-receive': {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'cancel_receive'
    },
    # 없음
    'cancel-reject': {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'cancel_reject'
    },
    'cancel-complete': {
      Cart: 'archived',
      ShipInfo: nil,
      # 결제 대기 상태일 때 취소 했을 수도 있고, 결제 완료 후 최소했을 수도 있다.
      Payment: { not_paid: 'pay_wait', paid: 'refund_complete' },
      OrderInfo: 'cancel_complete'
    },
    # 없음
    'refund-request': {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'refund_request'
    },
    # 없음
    'refund-receive': {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'refund_receive'
    },
    # 없음
    'refund-reject': {
      Cart: 'ordered',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'refund_reject'
    },
    # 없음
    'refund-complete': {
      Cart: 'archived',
      ShipInfo: nil,
      Payment: nil,
      OrderInfo: 'refund_complete'
    }
  }.freeze


  def up
    ApplicationRecord.country_context_with 'global' do
      # status code를 생성합니다.
      setup_order_component_statuses

      # 특정 상태의 cart들을 뽑아옵니다.
      STATUS_MAP.each do |cart_status, order_comps_stat|
        carts = Cart.where(order_status: cart_status)
        ap "Carts in #{cart_status} will be updated. (count : #{carts.count})"
        # hand면 패스합니다. 카트가 없으면 패스합니다.
        next if cart_status == :hand || carts.empty?

        carts.each do |c|
          order = c.order_info
          # order가 고의로 지워진 cart가 몇건 있습니다. 수동입력 주문들입니다.
          if order.nil?
            c.update_status(order_comps_stat[:Cart])
            next
          end

          # cancel 케이스는 결제 현황을 체크해서 반영해야 합니다.
          if %i[cancel-request cancel-complete].include? cart_status
            update_order_comps_status_with_payment_clue(order_comps_stat, order)
          else
            update_order_comps_by_stat_map(order_comps_stat, order)
          end
        end
      end
    end
  end
end

def down
  raise ActiveRecord::IrreversibleMigration
end

private

def setup_order_component_statuses
  order_components = [Cart, Payment, ShipInfo]

  order_components.each do |component|
    component.available_status.map do |status|
      Country.all.each do |country|
        component::StatusCode.find_or_create_by(name: status, country: country)
      end
    end
    ap "#{component.name} status codes are created."
  end
end

def update_order_comps_status_with_payment_clue(order_comps_stat, order)
  country = order.country
  # component 별개로 업데이트
  %i[Cart ShipInfo].each do |comp_class|
    update_comp_status(order.send(comp_class.to_s.underscore.to_sym), order_comps_stat[comp_class], country)
  end

  payment = order.payment
  clue = payment.paid? ? :paid : :not_paid
  update_comp_status(payment, order_comps_stat.dig(:Payment, clue), country)
  update_comp_status(order, order_comps_stat[:OrderInfo], country)
end

def update_order_comps_by_stat_map(order_comps_stat, order)
  country = order.country
  # 해당 상태의 component들의 status를 체크합니다.
  order_comps_stat.each do |comp_class, status|
    component = comp_class == :OrderInfo ? order : order.send(comp_class.to_s.underscore.to_sym)
    # 해당 상태의 order와 연결된 component의 status를 업데이트 합니다.
    update_comp_status(component, status, country)
  end
end

def update_comp_status(component, status, country)
  ap "======== #{component.class.name} | id : #{component.id} | status : #{status} ========"
  return component.update_status(status) if component.instance_of? OrderInfo

  status_code = component.class::StatusCode
  component.status_logs.create(status_code: status_code.where(name: status, country: country).first) unless status.nil?
end
