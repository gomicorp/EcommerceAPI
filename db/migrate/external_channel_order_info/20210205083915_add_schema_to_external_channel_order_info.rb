class AddSchemaToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_order_infos, :tracking_company_code, :string
    add_column :external_channel_order_infos, :confirmed_status, :string
    add_column :external_channel_order_infos, :source_name, :string
    add_column :external_channel_order_infos, :delivered_at, :datetime
  end
end
