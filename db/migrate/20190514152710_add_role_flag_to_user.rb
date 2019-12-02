class AddRoleFlagToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :is_manager, :boolean
    add_column :users, :is_seller, :boolean
  end
end
