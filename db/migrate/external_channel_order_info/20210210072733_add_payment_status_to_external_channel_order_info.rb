class AddPaymentStatusToExternalChannelOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :external_channel_order_infos, :payment_status, :string
  end
end
