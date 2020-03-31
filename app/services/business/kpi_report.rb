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
        }
      }
    end
  end
end
