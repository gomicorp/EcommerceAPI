class AddCustomerNameToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_order_infos, :customer_name, :string
  end
end
