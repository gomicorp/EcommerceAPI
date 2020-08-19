#=== order by seller store ===#
#=== item sold paper ===#
#ship_info_samples => 기존에 존재하는 가장 최근의 5개 ship info에서 reference와 timestamp를 제거, 샘플값으로 활용
ship_info_samples = OrderInfo.last(5).map(&:ship_info).map do |ship_info|
  ship_info.attributes.tap do |sample|
    sample.delete('id')
    sample.delete('order_info_id')
    sample.delete('created_at')
    sample.delete('updated_at')
    sample.update(ship_type: 'normal')
    sample
  end
end

# 주문이 가능한 유저데이터로, 스토어마다 주문을 5번 합니다.
# 5개의 주문 중 4개의 주문을 결제완료처리합니다.
ApplicationRecord.transaction do
  Seller.all.each do |seller|
    seller_store = seller.seller_info.store_info
    orderers = User.where(is_admin: nil, is_seller: nil, is_manager: nil).limit(100)
    5.times do
      #셀러의 스토어에 존재하는 상품 한개에서 세개
      products = seller_store.selected_products.sample((rand * 3).to_i + 1).map(&:product)
      #current cart가 비어있어, 상품을 추가하고 주문 생성이 가능한 user 한명
      orderer = orderers.select do |user|
        user.current_cart.items.empty?
      end.sample
      #대상 카트
      cart = orderer.current_cart
      cart_item_service = Store::CartItemService.new(cart, seller.seller_info)
      # 카트에 혹시 담겨있을 아이템을 뺍니다.
      cart_item_service.minus_all_item
      #카트에 대표상품을 1~3개 넣습니다.
      products.each do |product|
        cart_item_service.add(product.default_option.id, (rand * 3).to_i + 1)
      end
      order_param = {
          cart_id: cart.id,
          channel: Channel.default_channel
      }
      payment_param = {
          pay_method: 'bank'
      }
      order_create_service = Store::OrderCreateService.new(seller, order_param, ship_info_samples.sample, payment_param)
      order_create_service.save
    end
    seller.seller_info.order_infos.where(cart: Cart.where(order_status: 2)).all.each do |order_info|
      # 결제 완료
      paid_at = Time.zone.now
      order_info.payment.update!(paid: true, paid_at: paid_at)
      order_info.cart.update!(order_status: 3)
      # 셀러 수익을 반영
      seller_papers = order_info.cart.items.map(&:item_sold_paper).compact
      seller_papers.each do |paper|
        paper.apply_seller_profit
        paper.pay!
      end

      date_from = (Time.now - 1.month).to_f
      date_to = Time.now.to_f
      time = Time.at(rand * (date_to - date_from) + date_from)

      order_info.update!(ordered_at: time, created_at: time)
      order_info.cart.update!(created_at: time)
      order_info.payment.update!(created_at: time, paid_at: (time + 2.hours))
      order_info.ship_info.update!(created_at: time)
      items = order_info.items.where.not(item_sold_paper: nil)
      items.each do |item|
        item.update!(created_at: time)
        item.item_sold_paper.update!(created_at: time, paid_at: (time + 2.hours))
      end

      # 25퍼 확률로 취소시킵니다.
      if (rand * 4) < 1
        order_info.cart.update!(order_status: 7)
        order_cancel_service = Store::OrderCancelService.new(order_info.cart, {}, order_info.order_status)
        order_cancel_service.cancel!
      end
    end
  end
end

# 출금신청을 합니다. 돈이 없으면 못합니다.
ApplicationRecord.transaction do
  Seller.all.each do |seller|
    seller_info = seller.seller_info
    next if seller_info.withdrawable_profit.zero?

    settlement = Sellers::SettlementStatement.new(
        seller_info: seller_info,
        settlement_amount: seller_info.withdrawable_profit,
        status: 'requested',
        requested_at: Time.now
    )
    settlement.write_initial_state
    settlement.save

    date_from = (Time.now - 5.month).to_f
    date_to = Time.now.to_f
    time = Time.at(rand * (date_to - date_from) + date_from)

    settlement.update!(created_at: time, requested_at: time)
  end
end