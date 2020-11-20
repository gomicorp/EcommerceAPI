class CreateStoreSpecialPages < ActiveRecord::Migration[6.0]
  def change
    create_table :store_special_pages do |t|
      t.string :title
      t.datetime :published_at
      t.string :slug

      t.timestamps
    end
  end
end
