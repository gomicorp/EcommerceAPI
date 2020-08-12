class CreateStoreSections < ActiveRecord::Migration[6.0]
  def change
    create_table :store_sections do |t|
      t.references :country, foreign_key: true

      t.boolean :wide_mode,               null: false, default: false
      t.string :background_color,         null: false, default: '#ffffff'

      t.string :title,                    null: false, default: ''
      t.boolean :use_title,               null: false, default: true

      t.integer :connection_type,         null: false, default: 0
      t.integer :connection_col_count,    null: false, default: 4
      t.integer :connection_row_count,    null: false, default: 2

      t.timestamps
    end
  end
end
