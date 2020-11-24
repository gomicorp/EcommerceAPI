class AddHaravanIdToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :haravan_id, :string
  end
end
