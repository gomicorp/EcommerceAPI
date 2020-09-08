class AddAttributes3ToStoreSection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_sections, :sord, :integer, null: false, default: 0
  end
end
