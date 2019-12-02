class ExchangeOrderInfoAssociateWithCart < ActiveRecord::Migration[5.2]
  def change
    remove_column :carts, :order_info_id, :integer
    add_column :order_infos, :cart_id, :integer
  end
end
