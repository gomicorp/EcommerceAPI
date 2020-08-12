class AddViewPortToStoreSection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_sections, :view_port, :integer, null: false, default: 0
  end
end
