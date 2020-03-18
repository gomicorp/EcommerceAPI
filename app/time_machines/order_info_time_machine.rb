class OrderInfoTimeMachine < ApplicationTimeMachine
  def version_at(timestamp)
    super(timestamp) do |order_info|
      order_info.cart = order_info.cart.version_at timestamp
      order_info.cart.items = order_info.cart.items.map do |cart_item|
        CartItemTimeMachine.checkout(cart_item, timestamp)
      end
    end
  end

  # 깂이 변경된 적이 있다면 true 가 나오면 안됨
  def test
    selling_price_for = ->(order_info) { order_info.cart.items.first.product_option.bridges.first.connectable.selling_price }

    order = OrderInfo.find(subject.id)
    version_at order.created_at
    selling_price_for.call(subject) == selling_price_for.call(order)
  end


  private

  def index_graph
    [
      :payment,
      cart: {
        items: {
          product_option: [
            { option_group: :product },
            { bridges: :connectable }
          ]
        }
      }
    ]
  end
end
