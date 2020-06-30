class SetCapturedPricesToOrderedCartItems < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      OrderInfo.all.each do |order|
        order.items.each do |cart_item|
          timely_option = cart_item.product_option&.version_at(order.created_at) || ProductOption.zombie_find(cart_item.product_option_id)&.version_at(order.created_at)
          cart_item.update(
            captured_base_price: timely_option.base_price,
            captured_discount_price: timely_option.discount_price,
            captured_additional_price: timely_option.additional_price,
            captured_retail_price: timely_option.retail_price,
            captured_price_change: timely_option.price_change,
            captured: true
          ) if timely_option
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
