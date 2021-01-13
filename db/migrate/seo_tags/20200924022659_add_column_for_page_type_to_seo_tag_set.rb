class AddColumnForPageTypeToSeoTagSet < ActiveRecord::Migration[6.0]
  def change
    add_column :seo_tag_sets, :page_type, :string
  end
end
