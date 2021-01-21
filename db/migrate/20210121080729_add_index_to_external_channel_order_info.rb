class AddIndexToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_index :external_channel_order_infos, [:country_id]
    add_index :external_channel_order_infos, [:channel]
    add_index :external_channel_order_infos, [:external_channel_order_id]
    add_index :external_channel_order_infos, [:external_channel_order_id, :channel]
    add_index :external_channel_order_infos, [:external_channel_order_id, :country_id]
  end
end
