class ChangeOrderIdTypeInExternalOrderInfo < ActiveRecord::Migration[6.0]
  def change
    change_column :external_channel_order_infos, :external_channel_order_id, :string
  end
end
