module Business
  class KpiReport
    def self.call(date = Date.today)
      date = date.in_time_zone
      data_format = lambda do |orders|
        {
          count: orders.count,
          price: orders.map { |order| order.cart.final_price }.sum
        }
      end

      orders = OrderInfo.includes(:ship_info, cart: { items: [:product_option, :cancelled_tag] })
      users = User.where(is_admin: [false, nil], is_manager: [false, nil], is_seller: [false, nil])


      # 기간
      range = date.beginning_of_month..date.end_of_month

      # 주문 완료
      complete_data = data_format.call(orders.where(ordered_at: range).sold)

      # 주문 취소
      cancelled_data = data_format.call(orders.where(cart: Cart.where(items: CartItem.cancelled_at(range))))

      # 결제 수단별 유의미한 주문(결제수단이 나눠지는 시점 이후)
      orders_by_pay_method = lambda do |range, method|
        # 카드 기능 적용 일시
        card_applied_date = Date.new(2020,03,31)
        range = card_applied_date..range.last if range.first < card_applied_date

        orders.where(ordered_at: range).sold.where(payment: Payment.where(pay_method: method))
      end

      # 카드+현금 주문 완료
      card_and_bank_data = data_format.call(orders_by_pay_method.call(range, ['card','bank']))
      # 카드 주문 완료
      card_paid_data = data_format.call(orders_by_pay_method.call(range, 'card'))
      # 현금 주문 완료
      bank_paid_data = data_format.call(orders_by_pay_method.call(range, 'bank'))

      {
        duration: {
          from: range.first.strftime('%F'),
          to: range.last.strftime('%F'),
          length: 1.month
        },
        orders: {
          complete: complete_data,
          cancelled: cancelled_data,
          GMV: complete_data[:price] - cancelled_data[:price],
        },
        users: {
          newbie_count: users.where(created_at: range).count,
          buyer_count: users.where(carts: Cart.where(order_info: OrderInfo.where(ordered_at: range))).count,
          newbie_buyer_count: users.where(created_at: range).where(carts: Cart.where(order_info: OrderInfo.where(ordered_at: range))).count
        },
        pay_methods: {
          total_paid: card_and_bank_data,
          card_paid: card_paid_data,
          bank_paid: bank_paid_data
        }
      }
    end
  end
end
