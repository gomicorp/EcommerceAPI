class AddMarginToStoreSection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_sections, :margin_top, :boolean, null: false, default: true
    add_column :store_sections, :margin_bottom, :boolean, null: false, default: true
  end
end
