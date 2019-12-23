class AddEncIdToOrderInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :order_infos, :enc_id, :string
    add_index :order_infos, :enc_id, unique: true
  end
end
