class ChangeShippingStatusNullable < ActiveRecord::Migration[6.0]
  def change
    change_column :external_channel_order_infos, :shipping_status, :string, null: true
  end
end
