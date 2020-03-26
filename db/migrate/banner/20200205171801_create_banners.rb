class CreateBanners < ActiveRecord::Migration[6.0]
  def change
    create_table :banners do |t|
      t.integer :banner_type, null: false, default: 0
      t.string :href
      t.integer :position, null: false, default: 1
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
