class RemoveHaravanId < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :haravan_id
  end
end
