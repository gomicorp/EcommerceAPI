class AlterColumnToUtf8mb4 < ActiveRecord::Migration[6.0]
  def change
    change_table(:ship_infos, collate: :utf8mb4_general_ci, charset: :utf8mb4) {}
    change_column :ship_infos, :loc_detail, :text
  end
end
