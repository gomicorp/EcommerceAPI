class ChangeOrderStatusTypeInExternalOrderInfo < ActiveRecord::Migration[6.0]
  def change
    change_column :external_channel_order_infos, :order_status, :string
  end
end
