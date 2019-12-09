class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :name_ko
      t.string :locale

      t.timestamps
    end
  end
end
