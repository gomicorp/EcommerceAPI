class AddAttributesToStoreSectionConnection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_section_connections, :href, :string
    add_column :store_section_connections, :background_color, :string, null: false, default: '#ffffff'
  end
end
