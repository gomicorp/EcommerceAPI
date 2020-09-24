class CreateSeoTagAttributes < ActiveRecord::Migration[6.0]
  def change
    create_table :seo_tag_attributes do |t|
      t.references :seo_tag, index: true, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
