class SetCancelledTagIntoOldCancelledCartItem < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.transaction do
      PaperTrail.request(enabled: false) do
        OrderInfo.unscoped.order_status('cancel-complete').each do |order|
          order.cart.items.each do |cart_item|
            next if cart_item.cancelled_tag

            CartItemCancelledTag.create(
              cart_item: cart_item,
              cancelled_at: cart_item.cart.updated_at
            )
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
