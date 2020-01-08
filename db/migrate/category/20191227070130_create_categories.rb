class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.string :icon
      t.boolean :is_active, null: false, default: false

      t.timestamps
    end
  end
end
