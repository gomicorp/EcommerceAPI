class CreateSeoTagSets < ActiveRecord::Migration[6.0]
  def change
    create_table :seo_tag_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
