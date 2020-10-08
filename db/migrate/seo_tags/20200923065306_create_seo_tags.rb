class CreateSeoTags < ActiveRecord::Migration[6.0]
  def change
    create_table :seo_tags do |t|
      t.references :seo_tag_set, index: true, foreign_key: true
      t.string :tag_type

      t.timestamps
    end
  end
end
