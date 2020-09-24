class CreateSeoApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :seo_applications do |t|
      t.text :seo_properties
      t.string :page_type
      t.integer :page_id
      t.references :seo_tag_set, index: true, foreign_key: true

      t.timestamps
    end
  end
end
