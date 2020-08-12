class AddAttributes2ToStoreSection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_sections, :href, :string
    add_column :store_sections, :connection_limit, :integer, null: false, default: 30
  end
end
