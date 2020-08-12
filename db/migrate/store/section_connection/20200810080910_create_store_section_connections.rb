class CreateStoreSectionConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :store_section_connections do |t|
      t.references :store_section, null: false, foreign_key: true
      t.references :product

      t.integer :sord, null: false, default: 0
      # 배경색
      # 링크

      t.timestamps
    end
  end
end
