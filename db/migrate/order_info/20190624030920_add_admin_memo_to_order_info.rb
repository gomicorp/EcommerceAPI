class AddAdminMemoToOrderInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :order_infos, :admin_memo, :text
  end
end
