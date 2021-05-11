class SetOrderConfirmationForExistingOrders < ActiveRecord::Migration[6.0]
  MAP_FOR_ORDER_TO_CONFIRMATION = {
    pay_wait: "pending",
    paid: "confirmed",
    ship_prepare: "confirmed",
    ship_ing: "confirmed",
    ship_complete: "confirmed",
    refund_request: "confirmed",
    refund_reject: "confirmed",
    refund_complete: "confirmed",
    cancel_request: "confirmed",
    cancel_complete: "confirmed",
    order_complete: "confirmed"
  }.freeze

  INITIAL_CONFIRMATION_ATTR = {contact_count: 0, memo: ''}.freeze
  def up
    #==== 문제 있는 오래된 order가 발견되었습니다.
    # 2019년 7월 ~ 8월 사이 생성된 주문이고, cart에 담긴 item이 없습니다.
    # data stat 상으로 제거되어도 무관한 것으로 판단됩니다.
    # 문제의 범위인 order info와 cart를 삭제하는 것으로 처리합니다.
    no_status_old_order = OrderInfo.where(status: nil)
    ap "no_status_old_order: #{ no_status_old_order.count }"
    no_items_cart = no_status_old_order.map &:cart
    no_status_old_order.destroy_all
    Cart.where(id: no_items_cart.pluck(:id)).destroy_all
    ap 'order and cart destroyed.'
    #====

    orders = OrderInfo.all
    orders.each do |order|
      confirmation = order.build_order_confirmation(INITIAL_CONFIRMATION_ATTR)
      raise ActiveRecord::MigrationError unless confirmation.save!

      confirmation_status = MAP_FOR_ORDER_TO_CONFIRMATION[order.status.to_sym]
      confirmation.update_status(confirmation_status) if confirmation.current_status.nil? || confirmation.current_status.code != confirmation_status
      confirmation.reload; order.reload
      order.update_status
    end
  end

  def down
    migrated_confirmation = OrderConfirmation.where(INITIAL_CONFIRMATION_ATTR)
    migrated_order = OrderInfo.where(order_confirmation: migrated_confirmation)
    migrated_order.update_all(order_confirmation: nil)

    migrated_confirmation.destroy_all
  end
end
