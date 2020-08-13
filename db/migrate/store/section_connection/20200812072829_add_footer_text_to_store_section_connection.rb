class AddFooterTextToStoreSectionConnection < ActiveRecord::Migration[6.0]
  def change
    add_column :store_section_connections, :footer_text, :string
  end
end
