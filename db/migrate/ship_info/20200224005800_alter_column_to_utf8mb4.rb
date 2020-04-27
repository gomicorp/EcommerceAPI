class AlterColumnToUtf8mb4 < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE ship_infos CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    change_column :ship_infos, :loc_detail, :text
  end

  def down
    execute "ALTER TABLE ship_infos CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci"
    change_column :ship_infos, :loc_detail, :text
  end
end
