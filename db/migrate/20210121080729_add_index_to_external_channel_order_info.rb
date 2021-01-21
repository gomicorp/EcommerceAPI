class AddIndexToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_index :external_channel_order_infos, [:channel], name: 'ex_order_info_channel'
    add_index :external_channel_order_infos, [:external_channel_order_id], name: 'ex_order_info_ex_o_id'
    add_index :external_channel_order_infos, [:external_channel_order_id, :channel], name: 'ex_order_info_o_id_channel'
    add_index :external_channel_order_infos, [:external_channel_order_id, :country_id], name: 'ex_order_info_o_id_c_id'
  end
end
