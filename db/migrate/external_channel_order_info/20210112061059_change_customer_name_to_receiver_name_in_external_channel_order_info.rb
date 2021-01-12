class ChangeCustomerNameToReceiverNameInExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    rename_column :external_channel_order_infos, :customer_name, :receiver_name
  end
end
