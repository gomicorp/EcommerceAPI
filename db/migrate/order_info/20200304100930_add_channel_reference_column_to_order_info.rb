class AddChannelReferenceColumnToOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_infos, :channel, null: false
  end
end
