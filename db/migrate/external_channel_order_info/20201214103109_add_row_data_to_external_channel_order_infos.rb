class AddRowDataToExternalChannelOrderInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_order_infos, :row_data, :text
  end
end
