class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.text :title
      t.text :content
      t.datetime :period
      t.boolean :published
      t.string :domain
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
