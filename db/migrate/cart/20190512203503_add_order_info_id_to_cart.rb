class AddOrderInfoIdToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :order_info_id, :integer
  end
end
