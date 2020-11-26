class AddShippingStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_order_infos, :shipping_status, :string, null: false
  end
end
