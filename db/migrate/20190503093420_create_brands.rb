class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|
      t.references :company, foreign_key: true
      t.string :name
      t.string :eng_name

      t.timestamps
    end
  end
end
