class ChangeUtf8mb4ToShippingAddresses < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE shipping_addresses CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    change_column :shipping_addresses, :loc_detail, :text
  end

  def down
    execute "ALTER TABLE shipping_addresses CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci"
    change_column :shipping_addresses, :loc_detail, :text
  end
end
