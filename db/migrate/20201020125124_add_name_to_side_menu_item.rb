class AddNameToSideMenuItem < ActiveRecord::Migration[6.0]
  def change
    add_column :store_side_menu_items, :name, :string
  end
end
