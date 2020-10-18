class CreateStoreGnbMenuItems < ActiveRecord::Migration[6.0]
  def change
    create_table :store_gnb_menu_items do |t|
      t.text :name
      t.string :href, null: false, default: '#'
      t.integer :view_port, null: false, default: 0
      t.integer :sort_key, null: false, default: 0
      t.boolean :active, null: false, default: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
