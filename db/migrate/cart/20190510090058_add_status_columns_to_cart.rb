class AddStatusColumnsToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :active, :boolean, null: false, default: true
    add_column :carts, :current, :boolean, null: false, default: false
  end
end
