class RemoveOrderedAt < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_infos, :ordered_at
    remove_column :carts, :ordered_at
  end
end
