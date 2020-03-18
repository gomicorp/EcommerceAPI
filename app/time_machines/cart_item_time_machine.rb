class CartItemTimeMachine < ApplicationTimeMachine
  def version_at(timestamp)
    super(timestamp) do |cart_item|
      # option 복원
      cart_item.product_option = ProductOptionTimeMachine.checkout(cart_item.product_option, timestamp)
    end
  end
end
