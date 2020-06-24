class AddUniqueToCartIdForOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_index :order_infos, :cart_id, unique: true
  end
end
