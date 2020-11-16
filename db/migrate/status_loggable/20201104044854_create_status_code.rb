class CreateStatusCode < ActiveRecord::Migration[6.0]
  def change
    create_table :status_codes do |t|
      t.references :country, null: false, foreign_key: true
      t.string :domain_type
      t.string :name, null: false, default: ''
      t.text :comment

      t.timestamps
    end
  end
end
