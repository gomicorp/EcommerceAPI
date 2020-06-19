class CreateStatusCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :status_codes do |t|
      t.string :name, null: false, default: ''
      t.string :code, null: false, default: ''
      t.text :comment

      t.timestamps
    end
  end
end
